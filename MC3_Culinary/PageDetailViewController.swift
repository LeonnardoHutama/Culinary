//
//  PageDetailViewController.swift
//  MC3_Culinary
//
//  Created by Dionisius Ario Nugroho on 22/08/19.
//  Copyright © 2019 Leonnardo Benjamin Hutama. All rights reserved.
//

import UIKit

class PageDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var frame = CGRect(x:0, y:0, width: 0, height: 0)
    var bookmarked: Bool = false {
        didSet {
            setBookmarkIcon(bookmarked)
        }
    }
    
    @IBOutlet weak var foodNameDetail: UILabel!
    @IBOutlet weak var foodLocationDetail: UILabel!
    
    @IBOutlet weak var factDetail: UILabel!
    
    @IBOutlet weak var ingredientDetail: UILabel!
    
    @IBOutlet weak var methodDetail: UILabel!
    @IBOutlet weak var originLocation: UIImageView!
    
    var model: TraditionalFoodModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let bookmarklist = UserDefaults.standard.array(forKey: "bookmarklist"){
            let bookmark: [String] = bookmarklist as! [String]
            
            self.bookmarked = bookmark.contains(model!.name!)
        }
        
        foodNameDetail.text = model?.name
        foodLocationDetail.text = model?.origin?.name
        factDetail.text = model?.funFact
        ingredientDetail.text = model?.Ingredient
        methodDetail.text = model?.method
        
        var originName = model?.origin?.province.locationImage
        originLocation.image = UIImage (named: originName!)
        
//        title = model?.name
        title = ""

        pageControl.numberOfPages = model!.images!.count
        for index in 0..<model!.images!.count{
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: model!.images![index])
            self.scrollView.addSubview(imgView)
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(model!.images!.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
        
        //                funFact.text = """
        //                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget ex eros. Praesent accumsan a ligula ut tempus. Proin varius justo id arcu interdum, ut sodales orci dictum. Pellentesque varius interdum nulla, ut vestibulum massa pharetra id. Integer suscipit iaculis sem, nec dictum libero mollis quis. Vivamus finibus tempus mollis. Quisque at convallis dui. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.
        //                Pellentesque odio orci, auctor sollicitudin molestie id, imperdiet et ipsum. Curabitur vehicula diam non tempor tempus. Ut lacinia lacus a dolor dignissim, eget cursus dolor suscipit. Nulla et vehicula dolor, ac laoreet magna. Integer dictum fermentum velit at sodales. Etiam consequat sapien tincidunt odio faucibus cursus. Aliquam imperdiet aliquam faucibus. Pellentesque in nisi et ex malesuada semper. Donec eget pretium nunc. Quisque fermentum laoreet nunc eu placerat.
        //                """
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(pageNumber)
    }

    @IBAction func locTapped(_ sender: UIButton){
        searchRestaurant()
    }

    private func searchRestaurant(){
        var search = model?.name
        search = search?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)

        if let query = search {
            UIApplication.shared.openURL(URL(string:"https://www.google.com/maps/search/\(query)")!)
        }
    }

    @IBAction func addBookmark(_ sender: Any) {
//        let bookmarkVC : BookmarkViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bookmarkVC") as! BookmarkViewController
//        bookmarkVC.bookmarkFoodData = [TraditionalFoodModel(name: foodNameDetail.text!, images: ["\(model!.images!)"], fact: factDetail.text!, ingredient: ingredientDetail.text!, method: methodDetail.text!, origin: model!.origin!)]
//
//        self.present(bookmarkVC, animated: true, completion: nil)
//        print(model?)
        
        
        if bookmarked == false {
            bookmarked = true
            
            var bookmarklist: [String] = []
            
            if let bookmark = UserDefaults.standard.array(forKey: "bookmarklist") {
                bookmarklist = bookmark as! [String]
            }
            
            if !bookmarklist.contains(model!.name!){
                bookmarklist.append(model!.name!)
                UserDefaults.standard.setValue(bookmarklist, forKey: "bookmarklist")
                print("Bookmarked")
            }
            
            print(bookmarklist.count)
        }else if bookmarked == true{
            bookmarked = false
            if var bookmarklist = UserDefaults.standard.array(forKey: "bookmarklist") as? [String]{
                
                //cek array
                for (idx, name) in bookmarklist.enumerated(){
                    if name == model!.name!{
                        bookmarklist.remove(at: idx)
                        print("deleted row")
                        UserDefaults.standard.setValue(bookmarklist, forKey: "bookmarklist")
                        print(bookmarklist.count)
                    }
                }
                
            }
        }
    
    }
    
    private func setBookmarkIcon(_ value: Bool){
        if value == true {
            navigationItem.rightBarButtonItem?.image = UIImage(named: "BookmarkIsi")
        } else {
             navigationItem.rightBarButtonItem?.image = UIImage(named: "BookmarkNonIsi")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if bookmarked == true {
            navigationItem.rightBarButtonItem?.image = UIImage(named: "BookmarkIsi")
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(named: "BookmarkNonIsi")
        }
    }
}
