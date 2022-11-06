//
//  SwiftUIView.swift
//  TMDB-App
//
//  Created by Emin Saygı on 5.11.2022.
//

import SwiftUI

struct SettingsVC: View {
    @State var isOn = false
    @State var selection = "En"
   let lang = ["En","Tr","Gr"]
           
            
        
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    Toggle("Dark Mode",isOn: $isOn)
                        .onChange(of: isOn) { value in
                          
                            if #available(iOS 13.0, *){
                                       let appDelaggate = UIApplication.shared.windows.first
                                       
                                       if value {
                                           appDelaggate?.overrideUserInterfaceStyle = .dark
                                           return
                                       }
                                       appDelaggate?.overrideUserInterfaceStyle = .light
                                   }
                        }
                   
                }
               
                
            }
            
        }
     
       
    }
  
 
}

struct SettingsVC_Previews: PreviewProvider {
    static var previews: some View {
        SettingsVC()
    }
}

class SettingsVCBridge : UIHostingController<SettingsVC> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SettingsVC())
    }
}
