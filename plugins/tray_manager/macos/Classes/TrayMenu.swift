//
//  TrayMenu.swift
//  tray_manager
//
//  Created by Lijy91 on 2022/5/8.
//

import AppKit

public class TrayMenu: NSMenu, NSMenuDelegate {
    public var onMenuItemClick:((NSMenuItem) -> Void)?
    
    public override init(title: String) {
        super.init(title: title)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func menuItemTitle(_ label: String, _ sublabel: String) -> String {
        return sublabel.isEmpty ? label : "\(label)\t\(sublabel)"
    }
    
    public init(_ args: [String: Any]) {
        super.init(title: "")
        
        let items: [NSDictionary] = args["items"] as! [NSDictionary];
        for item in items {
            let menuItem: NSMenuItem
            
            let itemDict = item as! [String: Any]
            let id: Int = itemDict["id"] as! Int
            let type: String = itemDict["type"] as! String
            let label: String = itemDict["label"] as? String ?? ""
            let sublabel: String = itemDict["sublabel"] as? String ?? ""
            let toolTip: String = itemDict["toolTip"] as? String ?? ""
            let checked: Bool? = itemDict["checked"] as? Bool
            let disabled: Bool = itemDict["disabled"] as? Bool ?? true
            
            if (type == "separator") {
                menuItem = NSMenuItem.separator()
            } else {
                menuItem = NSMenuItem()
            }
            
            menuItem.tag = id
            menuItem.title = menuItemTitle(label, sublabel)
            menuItem.toolTip = toolTip
            menuItem.isEnabled = !disabled
            menuItem.action = !disabled ? #selector(statusItemMenuButtonClicked) : nil
            menuItem.target = self
            
            switch (type) {
            case "separator":
                break
            case "submenu":
                if let submenuDict = itemDict["submenu"] as? NSDictionary {
                    let submenu = TrayMenu(submenuDict as! [String : Any])
                    submenu.onMenuItemClick = { [weak self] (menuItem: NSMenuItem) in
                        guard let strongSelf = self else { return }
                        strongSelf.statusItemMenuButtonClicked(menuItem)
                    }
                    self.setSubmenu(submenu, for: menuItem)
                }
                break
            case "checkbox":
                if (checked == nil) {
                    menuItem.state = .mixed
                } else {
                    menuItem.state = checked! ? .on : .off
                }
                break
            default:
                break
            }
            self.addItem(menuItem)
        }
        self.delegate = self
    }
    
    @objc func statusItemMenuButtonClicked(_ sender: Any?) {
        if (sender is NSMenuItem && onMenuItemClick != nil) {
            let menuItem = sender as! NSMenuItem
            self.onMenuItemClick!(menuItem)
        }
    }
    
    // NSMenuDelegate
    
    public func menuDidClose(_ menu: NSMenu) {
        
    }
    
    public func updateMenuItems(_ args: [String: Any]) {
        let items: [NSDictionary] = args["items"] as! [NSDictionary];
        
        for (index, item) in items.enumerated() {
            if index < self.items.count {
                let menuItem = self.items[index]
                let itemDict = item as! [String: Any]
                let label: String = itemDict["label"] as? String ?? ""
                let sublabel: String = itemDict["sublabel"] as? String ?? ""
                let disabled: Bool = itemDict["disabled"] as? Bool ?? false
                let checked: Bool? = itemDict["checked"] as? Bool
                
                menuItem.title = menuItemTitle(label, sublabel)
                menuItem.isEnabled = !disabled
                menuItem.action = !disabled ? #selector(statusItemMenuButtonClicked) : nil
                
                if let checkedValue = checked {
                    menuItem.state = checkedValue ? .on : .off
                }
                
                if let submenuDict = itemDict["submenu"] as? NSDictionary,
                   let submenu = menuItem.submenu as? TrayMenu {
                    submenu.updateMenuItems(submenuDict as! [String : Any])
                }
            }
        }
    }
}
