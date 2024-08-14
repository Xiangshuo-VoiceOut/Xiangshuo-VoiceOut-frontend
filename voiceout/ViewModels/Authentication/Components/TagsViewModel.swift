//
//  TagsViewModel.swift
//  voiceout
//
//  Created by J. Wu on 7/30/24.
//

import Foundation
import SwiftUI


class TagsViewModel: ObservableObject{
    
    @Published var rows: [[BadgeTag]] = []
    @Published var tags: [BadgeTag]
    @Published var tagText = ""
    
    init(tags: [BadgeTag]){
        self.tags = tags
        getTags()
    }
    
    func addTag(){
        tags.append(BadgeTag(name: tagText))
        tagText = ""
        getTags()
    }
    
    func removeTag(by id: String){
        tags = tags.filter{ $0.id != id }
        getTags()
    }
    
    
    func getTags(){
        var rows: [[BadgeTag]] = []
        var currentRow: [BadgeTag] = []
        
        var totalWidth: CGFloat = 0
        
        let screenWidth = UIScreen.screenWidth - 6
        
        let padding: CGFloat = ViewSpacing.xlarge
        
        if !tags.isEmpty{
            
            for index in 0..<tags.count{
                self.tags[index].size = tags[index].name.getSize() + padding
            }
            
            tags.forEach{ tag in
                
                totalWidth += tag.size
                
                if totalWidth > screenWidth{
                    totalWidth = tag.size
                    rows.append(currentRow)
                    currentRow.removeAll()
                    currentRow.append(tag)
                }else{
                    currentRow.append(tag)
                }
            }
            
            if !currentRow.isEmpty{
                rows.append(currentRow)
                currentRow.removeAll()
            }
            
            self.rows = rows
        }else{
            self.rows = []
        }
        
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.width
}

extension String{
    func getSize() -> CGFloat{
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size.width
    }
}
