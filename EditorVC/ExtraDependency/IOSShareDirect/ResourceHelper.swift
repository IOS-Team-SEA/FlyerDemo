//
//  ResourceHelper.swift
//  IOSMediaView
//
//  Created by JD on 8/25/20.
//

import Foundation
//import IOS_CommonUtil
import IOS_CommonUtilSPM
import UIKit

public class Resource {
    
   
    
    static func getPodBundle(for name : String , ext : String , className : AnyClass = Resource.self) -> Bundle? {
        
       
            
            let appBundle = Bundle(for: className.self)
            if let bundleUrl = appBundle.url(forResource: "IOSShareDirect", withExtension: "bundle") {
                if let podBundle = Bundle(url: bundleUrl) {
                    if podBundle.url(forResource: name, withExtension: ext) != nil {
                        return podBundle
                    }
                }
            }else if Bundle.main.path(forResource: name, ofType: ext) != nil {
                return  Bundle.main
            }
        
        return nil
    }
    
public   static func getImage(name: String , ext : String = "png") -> UIImage? {
        if let bundle = Resource.getPodBundle(for: name, ext: ext) {
            if #available(iOS 13.0, *) {
                if let image = UIImage(named: name, in: bundle, with: nil) {
                    return image
                }
            } else {
                if let image =  UIImage(named: name, in: bundle, compatibleWith: nil) {
                    return image
                }
               
            }
        }
        return nil
    }

    public class func  getNibFromPodBundle<T: UINib>(named name: String, cellIdentifier : String ,bundle: Bundle? = nil, filesOwner: AnyObject = NSNull.init(),className : AnyClass) -> T? {
        if let nib : T =  createNib(named: name, bundle: bundle, filesOwner: filesOwner, className: className) {
              return nib
            }
              return nil
               }
        
    fileprivate  class func createNib<T: UINib>(named name: String, bundle: Bundle? = nil, filesOwner: AnyObject = NSNull.init(),className : AnyClass)  -> T? {
            var resolvedBundle: Bundle?
            if let bundle = bundle {
           resolvedBundle = bundle
            }else{
                resolvedBundle = Resource.getPodBundle(for: name, ext: "nib",className: className)
            }

        if let cellNib = UINib(nibName: name, bundle: resolvedBundle) as? T {
            return cellNib
        }
            return nil
        }
  
    
    
    

        
    
}
extension String {
 func localised() -> String{
    if let bundle = Resource.getPodBundle(for: "Localizable", ext: "strings") {
    let localizedString = NSLocalizedString(self, bundle: bundle, comment: "")

        if(localizedString == self){
            if(localizedString.contains("_")){
                print("No Localization done for \(self)")
            }
        }
        return localizedString;
}
    print("No Localization done for \(self)")
    return self
 }
}
public extension UIView {
    /**
               Loads a nib file with specified name in the specified bundle and returns the
               first view found in the  nib file with matching type `T`.
               
               - Parameter name: The name of the nib file (excluding the .xib extension).
               - Parameter bundle: The name of the bundle containing the nib file.
               - Parameter filesOwner: An optional files owner.
               
               - Throws: `Error.CannotLoadViewFromNib` if a view matching the
               generic type `T` is not found in the nib.
               
               - Returns: An instance of generic view type `T`.
               */
    class func viewFromNib<T: UIView>(named name: String, bundle: Bundle, filesOwner: AnyObject = NSNull.init()) throws -> T {
                  let view: T = try internalViewFromNib(named: name, bundle: bundle, filesOwner: filesOwner)
                  return view
              }
    fileprivate class func internalViewFromNib<T: UIView>(named name: String, bundle: Bundle? = nil, filesOwner: AnyObject = NSNull.init()) throws -> T {
           let resolvedBundle: Bundle
           if let bundle = bundle {
               resolvedBundle = bundle
           } else {
               if Bundle.main.path(forResource: name, ofType: "nib") != nil {
                   resolvedBundle = Bundle.main
               } else {
                resolvedBundle = Resource.getPodBundle(for: name, ext: "nib")!
               }
           }
           let arrayOfViews = resolvedBundle.loadNibNamed(name, owner: filesOwner, options: nil) ?? []
           #if swift(>=4.1)
           guard let view = arrayOfViews.compactMap( { $0 as? T} ).first else { throw SwiftError.float(name, message: "Can not load from nib") }
           #else
           guard let view = arrayOfViews.flatMap( { $0 as? T} ).first else { throw SwiftError.cannotLoadViewFromNib(nibName: name) }
           #endif
           return view
       }
  public  static var nib: UINib {
        
        return Resource.getNibFromPodBundle(named: "\(self)", cellIdentifier: "\(self)",className : self)!
    }
    
    static func instantiateFromNib() -> Self? {
         
         func instanceFromNib<T: UIView>() ->T? {
             
             return nib.instantiate() as? T
         }
         
        return instanceFromNib()
     }

}

public extension UINib {
    
    func instantiate() -> Any? {
        
        return self.instantiate(withOwner: nil, options: nil).first
    }
  
}

//
//extension UICollectionViewCell : IdentifiableCell {
//
//    public static var identifier: String {
//
//        return "\(self)"
//    }
//}
//extension UITableViewCell : IdentifiableCell {
//
//    public static var identifier: String {
//
//        return "\(self)"
//    }
//}

public extension UICollectionView {
    
    
    
    func register<T>(cell: T.Type) where  T: UICollectionViewCell {
        register(cell.nib, forCellWithReuseIdentifier: cell.identifier)
        
    }
    
    func dequeueReusableCell<T: IdentifiableCell>(with cell: T.Type , indexPath : IndexPath) -> T? {
        let cell = dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as? T
        return cell
    }
    
}
public extension UITableView {
    
    
    
    func register<T>(cell: T.Type) where  T: UICollectionViewCell {
               register(cell.nib, forCellReuseIdentifier: cell.identifier)
    }
    
    func dequeueReusableCell<T: IdentifiableCell>(with cell: T.Type , indexPath : IndexPath) -> T? {
        
        return dequeueReusableCell(withIdentifier: cell.identifier) as? T
    }
    
}
