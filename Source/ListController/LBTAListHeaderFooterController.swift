
//
//  LBTAListHeaderFooterController.swift
//  LBTATools
//
//  Created by Brian Voong on 6/25/19.
//

import UIKit

/**
 ListHeaderFooterController helps register, dequeues, and sets up cells with their respective items to render in a standard single section list.
 
 ## Generics ##
 T: the cell type that this list will register and dequeue.
 
 U: the item type that each cell will visually represent.
 
 H: the header type above the section of cells.
 
 F: the footer type below the section of cells
 
 */
@available(iOS 11.0, tvOS 11.0, *)
open class LBTAListHeaderFooterController<T: LBTAListCell<U>, U, H: UICollectionReusableView, F: UICollectionReusableView>: UICollectionViewController {
    
    /// An array of U objects this list will render. When using items.append, you still need to manually call reloadData.
    //MARK:基类的items赋值，刷新列表
    let imageSize: CGSize = CGSize(width: 152, height: 100) //根据空白图的实际大小调整参数
    open var headerHeight: CGFloat = 0
    open var notData: Bool = false
    
    open var items = [U]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
                self.removeEmptyDataImage()
                if self.notData {
                    self.showEmptyDataImage()
                }
                
            }
        }
    }
    
    
    fileprivate let cellId = "cellId"
    fileprivate let supplementaryViewId = "supplementaryViewId"
    
    /// Return an estimated height for proper indexPath using systemLayoutSizeFitting.
    open func estimatedCellHeight(for indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let cell = T()
        let largeHeight: CGFloat = 1000
        cell.frame = .init(x: 0, y: 0, width: cellWidth, height: largeHeight)
        cell.item = items[indexPath.item]
        cell.layoutIfNeeded()
        
        return cell.systemLayoutSizeFitting(.init(width: cellWidth, height: largeHeight)).height
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
        collectionView.backgroundColor = .white
        
        
        collectionView.register(T.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(H.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: supplementaryViewId)
        collectionView.register(F.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: supplementaryViewId)
    }
    
    /// ListHeaderController automatically dequeues your T cell and sets the correct item object on it.
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! T
        cell.item = items[indexPath.row]
        cell.parentController = self
        return cell
    }
    
    /// Override this to manually set up your header with custom behavior.
    open func setupHeader(_ header: H) {}
    
    open func setupFooter(_ footer: F) {}
    
    override open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementaryViewId, for: indexPath)
        if let header = supplementaryView as? H {
            setupHeader(header)
        } else if let footer = supplementaryView as? F {
            setupFooter(footer)
        }
        return supplementaryView
    }
    //MARK:基类实现items的个数协议
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    /// If you don't provide this, headers and footers for UICollectionViewControllers will be drawn above the scroll bar.
    override open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        view.layer.zPosition = -1
    }
    
    /**
     Initializes your ListHeaderController with a plain UICollectionViewFlowLayout.
     
     ## Parameters ##
     layout: use the layout you desire such as UICollectionViewFlowLayout or UICollectionViewCompositionalLayout
     
     scrollDirection: direction that your cells will be rendered
     
     */
    
    public init(layout: UICollectionViewLayout = UICollectionViewFlowLayout(), scrollDirection: UICollectionView.ScrollDirection = .vertical) {
        if let layout = layout as? UICollectionViewFlowLayout {
            layout.scrollDirection = scrollDirection
        }
        super.init(collectionViewLayout: layout)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("You most likely have a Storyboard controller that uses this class, please remove any instance of LBTAListHeaderController or sublasses of this component from your Storyboard files.")
    }
    
    //MARK: 先移除已经存在的空白页内容
    private  let emptyDataIdentifier = "emptyDataIdentifier"
    func removeEmptyDataImage() {
        for item in self.view.subviews {
            if item.restorationIdentifier == emptyDataIdentifier {
                for view in item.subviews {
                    view.removeFromSuperview()
                }
                item.removeFromSuperview()
            }
        }
    }
    //MARK:任何添加空白页内容
    func showEmptyDataImage() {
        
        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height+40))
        //这里注意图片资源的名字，在项目图片资源导入
        let emptyImage = UIImageView(image: UIImage(named: "empty-image-default"))
        emptyImage.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        bottomView.addSubview(emptyImage)
        
        let nameLabel = UILabel.init()
        nameLabel.text = "暂无数据"
        nameLabel.textColor = UIColor.lightGray //UIColor(red: 153, green: 153, blue: 153, alpha: 1)
        nameLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.frame = CGRect(x: 0, y: imageSize.height+10, width: imageSize.width, height: 20)
        bottomView.addSubview(nameLabel)
        
        self.view.addSubview(bottomView)
        self.view.bringSubviewToFront(bottomView)
        bottomView.restorationIdentifier = emptyDataIdentifier
        bottomView.withWidth(imageSize.width).withHeight(imageSize.height+40)
       
        if headerHeight == 0 {
            bottomView.centerInSuperview()
        }else {
            bottomView.anchor(.top(self.view.topAnchor, constant: headerHeight+10))
            bottomView.centerXToSuperview()
        }
        
    }
    
}


