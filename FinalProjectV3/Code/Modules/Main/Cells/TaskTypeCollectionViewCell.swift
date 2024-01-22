//
//  TaskTypeCollectionViewCell.swift
//  FinalProjectV3
//
//  Created by Thanawat Sriwanlop on 6/11/2565 BE.
//

import UIKit

class TaskTypeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - outlet
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var typeName: UILabel!
    
    // MARK: - variables

    
    
    
    // MARK: - lifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.imageContainerView.layer.cornerRadius = self.imageContainerView.bounds.width / 2
        }
    }
    
    
    // MARK: - functions
    override class func description() -> String {
         return "TaskTypeCollectionViewCell"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
        self.imageView.image = nil
    }
    
    func setupCell(taskType: TaskType, isSelected: Bool) {
        self.typeName.text = taskType.typeName
        
        if (isSelected) {
            self.imageContainerView.backgroundColor = UIColor(hex: "17b840").withAlphaComponent(0.75)
            self.typeName.textColor = UIColor(hex: "006666")
            self.imageView.tintColor = UIColor.white
            self.imageView.image = UIImage(systemName: taskType.symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
        } else {
            self.imageView.image = UIImage(systemName: taskType.symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
            reset()
        }
    }
    

    
    func reset() {
        self.imageContainerView.backgroundColor = UIColor.clear
        self.typeName.textColor = UIColor.white
        self.imageView.tintColor = UIColor.white
//        self.typeName.backgroundColor = UIColor.black
//        self.imageView.backgroundColor = UIColor.black
    }
}
