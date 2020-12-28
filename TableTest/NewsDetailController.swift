//
//  NewsDetailController.swift
//  TableTest
//
//  Created by 이종하 on 2020/12/21.
//

import UIKit

class NewsDetailController : UIViewController {
    
    @IBOutlet weak var ImageMain: UIImageView!
    @IBOutlet weak var LabelMain: UILabel!
    
    
    //1. Image url
    //2. desc
    
    var imageUrl: String?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //값이 들어있으면
        if let img = imageUrl {
            //이미지 가져와서 뿌림
            //Data
            if let data = try? Data(contentsOf: URL(string: img)!) {
                    //Main Thread
                DispatchQueue.main.async {
                    self.ImageMain.image = UIImage(data: data)
                }
            }
        }
        
        //값이 들어있으면
        if let d = desc {
            //본문을 보여줌
            self.LabelMain.text = d
        }

        
    }
    
   
}
