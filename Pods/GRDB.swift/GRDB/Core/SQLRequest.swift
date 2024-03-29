/// An SQL request that can decode database rows.
///
/// `SQLRequest` allows you to safely embed raw values in your SQL,
/// without any risk of syntax errors or SQL injection:
///
/// ```swift
/// extension Player {
///     static func filter(name: String) -> SQLRequest<Player> {
///         "SELECT * FROM player WHERE name = \(name)"
///     }
/// }
///
/// try dbQueue.read { db in
///     let players = try Player.filter(name: "O'Brien").fetchAll(db)
/// }
/// ```
///
/// An `SQLRequest` can be created from a string literal, as in the above
/// example, or from one of the initializers documented below.
///
/// ## Topics
///
/// ### Creating an SQL Request from a Literal Value
///
/// - ``init(stringLiteral:)``
/// - ``init(unicodeScalarLiteral:)-84mq8``
/// - ``init(extendedGraphemeClusterLiteral:)-1sf75``
///
/// ### Creating an SQL Request from an Interpolation
///
/// - ``init(stringInterpolation:)``
///
/// ### Creating an SQL Request from an SQL Literal
///
/// - ``init(literal:adapter:cached:)-4vuxn``
/// - ``init(literal:adapter:cached:)-82f97``
///
/// ### Creating an SQL Request from an SQL String
///
/// - ``init(sql:arguments:adapter:cached:)-3qq8t``
/// - ``init(sql:arguments:adapter:cached:)-5ecx2``
public struct SQLRequest<RowDecoder> {
    /// There are two statement caches: one "public" for statements generated by
    /// the user, and one "internal" for the statements generated by GRDB. Those
    /// are separated so that GRDB has no opportunity to inadvertently modify
    /// the arguments of user's cached statements.
    enum Cache {
        /// The public cache, for library user
        case `public`
        
        /// The internal cache, for GRDB
        case `internal`
    }
    
    /// The row adapter.
    public var adapter: (any RowAdapter)?
    
    private(set) var sqlLiteral: SQL
    let cache: Cache?
    
    private init(
        literal sqlLiteral: SQL,
        adapter: (any RowAdapter)?,
        fromCache cache: Cache?,
        type: RowDecoder.Type)
    {
        self.sqlLiteral = sqlLiteral
        self.adapter = adapter
        self.cache = cache
    }
}

extension SQLRequest {
    /// Creates a request from an SQL string.
    ///
    /// ```swift
    /// let request = SQLRequest<String>(sql: """
    ///     SELECT name FROM player
    ///     """)
    /// let request = SQLRequest<Player>(sql: """
    ///     SELECT * FROM player WHERE name = ?
    ///     """, arguments: ["O'Brien"])
    /// ```
    ///
    /// - parameters:
    ///     - sql: An SQL string.
    ///     - arguments: Statement arguments.
    ///     - adapter: Optional RowAdapter.
    ///     - cached: Defaults to false. If true, the request reuses a cached
    ///       prepared statement.
    public init(
        sql: String,
        arguments: StatementArguments = StatementArguments(),
        adapter: (any RowAdapter)? = nil,
        cached: Bool = false)
    {
        self.init(
            literal: SQL(sql: sql, arguments: arguments),
            adapter: adapter,
            fromCache: cached ? .public : nil,
            type: RowDecoder.self)
    }
    
    /// Creates a request from an ``SQL`` literal.
    ///
    /// ``SQL`` literals allow you to safely embed raw values in your SQL,
    /// without any risk of syntax errors or SQL injection:
    ///
    /// ```swift
    /// let name = "O'Brien"
    /// let request = SQLRequest<Player>(literal: """
    ///     SELECT * FROM player WHERE name = \(name)
    ///     """)
    /// ```
    ///
    /// - parameters:
    ///     - sqlLiteral: An `SQL` literal.
    ///     - adapter: Optional RowAdapter.
    ///     - cached: Defaults to false. If true, the request reuses a cached
    ///       prepared statement.
    public init(literal sqlLiteral: SQL, adapter: (any RowAdapter)? = nil, cached: Bool = false) {
        self.init(
            literal: sqlLiteral,
            adapter: adapter,
            fromCache: cached ? .public : nil,
            type: RowDecoder.self)
    }
}

extension SQLRequest<Row> {
    /// Creates a request of database rows, from an SQL string.
    ///
    /// ```swift
    /// let request = SQLRequest(sql: """
    ///     SELECT * FROM player WHERE name = ?
    ///     """, arguments: ["O'Brien"])
    /// ```
    ///
    /// - parameters:
    ///     - sql: An SQL string.
    ///     - arguments: Statement arguments.
    ///     - adapter: Optional RowAdapter.
    ///     - cached: Defaults to false. If true, the request reuses a cached
    ///       prepared statement.
    public init(
        sql: String,
        arguments: StatementArguments = StatementArguments(),
        adapter: (any RowAdapter)? = nil,
        cached: Bool = false)
    {
        self.init(
            literal: SQL(sql: sql, arguments: arguments),
            adapter: adapter,
            fromCache: cached ? .public : nil,
            type: Row.self)
    }
    
    /// Creates a request of database rows, from an ``SQL`` literal.
    ///
    /// ``SQL`` literals allow you to safely embed raw values in your SQL,
    /// without any risk of syntax errors or SQL injection:
    ///
    /// ```swift
    /// let name = "O'Brien"
    /// let request = SQLRequest(literal: """
    ///     SELECT * FROM player WHERE name = \(name)
    ///     """)
    /// ```
    ///
    /// - parameters:
    ///     - sqlLiteral: An `SQL` literal.
    ///     - adapter: Optional RowAdapter.
    ///     - cached: Defaults to false. If true, the request reuses a cached
    ///       prepared statement.
    public init(literal sqlLiteral: SQL, adapter: (any RowAdapter)? = nil, cached: Bool = false) {
        self.init(
            literal: sqlLiteral,
            adapter: adapter,
            fromCache: cached ? .public : nil,
            type: Row.self)
    }
}

extension SQLRequest: FetchRequest {
    public var sqlSubquery: SQLSubquery {
        .literal(sqlLiteral)
    }
    
    public func fetchCount(_ db: Database) throws -> Int {
        try SQLRequest<Int>("SELECT COUNT(*) FROM (\(self))").fetchOne(db)!
    }
    
    public func makePreparedRequest(
        _ db: Database,
        forSingleResult singleResult: Bool = false)
    throws -> PreparedRequest
    {
        let context = SQLGenerationContext(db)
        let sql = try sqlLiteral.sql(context)
        let statement: Statement
        switch cache {
        case .none:
            statement = try db.makeStatement(sql: sql)
        case .public?:
            statement = try db.cachedStatement(sql: sql)
        case .internal?:
            statement = try db.internalCachedStatement(sql: sql)
        }
        try statement.setArguments(context.arguments)
        return PreparedRequest(statement: statement, adapter: adapter)
    }
}

extension SQLRequest: ExpressibleByStringInterpolation {
    public init(unicodeScalarLiteral: String) {
        self.init(sql: unicodeScalarLiteral)
    }
    
    public init(extendedGraphemeClusterLiteral: String) {
        self.init(sql: extendedGraphemeClusterLiteral)
    }
    
    /// Creates an `SQLRequest` from the given literal SQL string.
    public init(stringLiteral: String) {
        self.init(sql: stringLiteral)
    }
    
    public init(stringInterpolation sqlInterpolation: SQLInterpolation) {
        self.init(literal: SQL(stringInterpolation: sqlInterpolation))
    }
}
