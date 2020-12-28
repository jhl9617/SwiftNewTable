//
//  ViewController.swift
//  TableTest
//
//  Created by 이종하 on 2020/12/18.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    
    var newsData :Array<Dictionary<String, Any>>?
    
    
    //1. http 통신 방법 01000010101110100
    //2. Json 데이터 형태 {"돈":"10000"} {[{"100"},{"2000"},{"100,00"},{"꽝"}]}
    //3. 테이블 뷰의 데이터 매칭!! 통보 하고 그리기
    // 네트워크 통신은 백그라운드. 화면 그리기는 메인
/*    {
        [
            {"돈":"100"},
            {"돈":"2000"},
            {"돈":"100,00"},
            {"돈":"꽝"}
        ]
        
    }
 */
    
    
    //하루 500회 무료
    func getNews() {
        let task = URLSession.shared.dataTask(with: URL(string: "http://newsapi.org/v2/top-headlines?country=kr&apiKey=1b826120729c4c5db870f7217162292e")!) { (data, response, error) in
            
            if let dataJson = data {
                
                //json parsing 변환
                
                do {
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                   
                    
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    
                    print(articles)
                    self.newsData = articles
                    
                    //데이터 비동기
                    DispatchQueue.main.async {
                        self.TableViewMain.reloadData()
                    }
                    
                    
                    
                }
                catch{}
            }
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //몇개? 숫자
        
        if let news = newsData {
            return news.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //무엇? 반복 10번??
        //1번 방법 - 임의의 셀 만들기
        
        //let cell = UITableViewCell.init(style: .default, reuseIdentifier: "TableCellType")
        
        //cell.textLabel?.text = "\(indexPath.row)"
        
        //2번 방법 - 스토리보드
        let cell = tableView.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        
        let idx = indexPath.row
        
        if let news = newsData {
             
            let row = news[idx]
            if let r = row as? Dictionary<String, Any> {
                
                if let title = r["title"] as? String{
                    cell.LabelText.text = title
                }
                
            }
            
        }
        
        
        
        
        //as? as! - 부모 자식 친자 확인
        //as? 맞아?
        //as! 맞아!
        
        
        return cell
    }
    
    //1. 옵션 - 클릭 감지
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("CLICK!!! \(indexPath.row)")
        
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "NewsDetailController") as! NewsDetailController
        
        if let news = newsData {
             
            let row = news[indexPath.row]
            if let r = row as? Dictionary<String, Any> {
                
                if let imageUrl = r["urlToImage"] as? String{
                    controller.imageUrl = imageUrl
                }
                if let desc = r["description"] as? String{
                    controller.desc = desc
                }
                
            }
            
        }
        //이동 - 수동
        //showDetailViewController(controller, sender: nil)
        
    }
    
    
    

    
    
    //2. 세그웨이
    //어떤 컨트롤러나 클래스에서 부모가 (가나다) 메소드를 가지고 있으면  자식도 (가나다) 사용 가능
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "NewsDetail" == id {
            if let controller = segue.destination as? NewsDetailController {
                
                if let news = newsData {
                    if let indexpath = TableViewMain.indexPathForSelectedRow {
                        let row = news[indexpath.row]
                        if let r = row as? Dictionary<String, Any> {
                            
                            if let imageUrl = r["urlToImage"] as? String{
                                controller.imageUrl = imageUrl
                            }
                            if let desc = r["description"] as? String{
                                controller.desc =  desc
                            }
                            
                        }
                    }
                    
                    
                    
                }

            }
        }
        
        //이동 - 자동
    }
    
    
    
    
    
    
    //1. 디테일 (상세) 화면 만들기
    //2. 값을 보내기 2단계
    //1. Tableview delegate / 2. storyboard (segue)
    //3. 화면 이동 (이동하기 전에 값을 미리 셋팅해야한다!!!!!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
        
        getNews()
    }
    
    //tableView 여러개의 행이 모여 있는 목록 뷰 (화면)
    //정갈하게 보여주려고 (ex 전화번호부)
    
    // 1. 데이터 무엇? - 전화번호부 목록
    // 2. 데이터 몇개? - 100, 1000, 10000
    // 3. (옵션) 데이터 행 눌렀다 - 클릭
    
    
    


}

