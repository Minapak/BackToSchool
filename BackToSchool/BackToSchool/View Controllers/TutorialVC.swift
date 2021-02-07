//
//  TutorialVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit

class TutorialCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgTutorial: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
}

class TutorialVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collection_tutorial: UICollectionView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: Variables
    var tutorialArr =
        [
        
                       ["image":"video",
                        "title":"Live 수업",
                        "description":"선생님이 직접 Live로 수업을 하여 집에서도, 독서실에서도 언제 어디서나 공부 할 수 있어요!"],
                       
                       ["image":"play.tv",
                        "title":"다양한 수업 영상",
                        "description":"중간고사, 기말고사, 쪽지시험을 대비한 여러 수업 영상을 시청 할 수 있어요!."],
                       
                       ["image":"calendar",
                        "title":"나만의 시간표",
                        "description":"다양한 카테고리의 수업을 나만의 시간표로 만들어 공부 할 수 있어요!"],
                       
                       ["image":"scroll",
                        "title":"다양한 수업 자료",
                        "description":"선생님, 친구들, 내가 올리는 수업자료를 다운로드 받아 교재를 만들 수 있어요!."]
                       
//                       ["image":"person.circle",
//                        "title":"User Profile",
//                        "description":"See other user profile and wallpapers uploaded by them."]
    
    ]
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnSkip.layer.borderColor = UIColor.white.cgColor
        self.btnSkip.layer.borderWidth = 1.0
        self.btnSkip.layer.cornerRadius = 8.0
    }
    
}

//MARK: Actions
extension TutorialVC {
    @IBAction func btnSkip_Clicked(_ sender: UIButton) {
        UserDefaults.standard.set("1", forKey: UD_isTutorial)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let objVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let nav : UINavigationController = UINavigationController(rootViewController: objVC)
        nav.navigationBar.isHidden = true
        UIApplication.shared.windows[0].rootViewController = nav

    }
}

//MARK: Collectionview methods
extension TutorialVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorialArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collection_tutorial.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionCell", for: indexPath) as! TutorialCollectionCell
        cell.imgTutorial.image = UIImage(systemName: self.tutorialArr[indexPath.item]["image"]!)
        cell.lblTitle.text = self.tutorialArr[indexPath.item]["title"]
        cell.lblDescription.text = self.tutorialArr[indexPath.item]["description"]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20.0)
    }
}

//MARK: Functions
extension TutorialVC {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = self.collection_tutorial.contentOffset
        visibleRect.size = self.collection_tutorial.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = self.collection_tutorial.indexPathForItem(at: visiblePoint) else { return }
        self.pageControl.currentPage = indexPath.item
        if indexPath.item == 4 {
            self.btnSkip.setTitle("START", for: .normal)
        }
        else {
            self.btnSkip.setTitle("SKIP", for: .normal)
        }
    }
}
