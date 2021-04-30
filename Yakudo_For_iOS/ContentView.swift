//
//  ContentView.swift
//  Yakudo_For_iOS
//
//  Created by 多根直輝 on 2021/04/20.
//

import SwiftUI

struct ContentView: View {
    var image: UIImage?
    @State var yakudoImage: UIImage? = UIImage()
    @ObservedObject private var avFoundationView = AVFoundationView()
    @ObservedObject private var orientation:OrientationObserver = OrientationObserver()
    @State var current_orientation: UIDeviceOrientation = .portrait
    @State var previous_orientation: UIDeviceOrientation = .portrait
    @State var showAlert = false
    @State private var inPhotoLibrary = false
    @State private var presentingSafariView = false
    @Environment(\.openURL) var openURL

    init() {
        // test用
//        image = UIImage.init(named: "カメラアイコン8.jpeg")
////        filteredImage = {
////                OpenCVTest.filteredImage(image)
////            }()
//        yakudoImage = {
//            Yakudo.yakudo(image)
//        }()
//        avFoundationView.image = yakudoImage
        
    }
    var body: some View {
//        ZStack {
//            if self.filteredImage != nil {
//                Image(uiImage: self.filteredImage!)
//                    .resizable()
//                    .aspectRatio(self.filteredImage!.size, contentMode: .fit)
//            } else {
//                Text("No Image")
//            }
//        }
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
                
            if avFoundationView.image == nil {
                
                if current_orientation.isLandscape  {
                    HStack {
                        LandscapeCALayerView(caLayer: avFoundationView.previewLayer)
                            .onAppear {
                                print("landscape")
                                //self.orientation.addObserver()
                            }.onDisappear {
                                //self.orientation.removeObserver()
                            }

                        HStack {
                            Button(action: {
                                self.avFoundationView.takePhoto()
                            }) {
                                Image(systemName: "camera.circle.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.gray.opacity(0))
                            }
                            
                        }
                        .padding(.leading, 50.0)
                        Spacer()
                    }
                    .onAppear() {
                        previous_orientation = current_orientation
                    }
                    
                }
                else if current_orientation == .portrait  {
                    VStack {
                        PortraitCALayerView(caLayer: avFoundationView.previewLayer)
                            .onAppear {
                                print("portrait")
                                //self.orientation.addObserver()
                            }.onDisappear {
                                //self.orientation.removeObserver()
                            }

                        HStack {
                            Button(action: {
                                self.avFoundationView.takePhoto()
                            }) {
                                Image(systemName: "camera.circle.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.gray.opacity(0))
                            }
                            
                        }
                        .padding(.bottom, 50.0)
                        Spacer()
                    }
                    .onAppear() {
                        previous_orientation = current_orientation
                    }
                    
                }
                else {
                    
                    if previous_orientation.isPortrait  {
                        VStack {
                            PortraitCALayerView(caLayer: avFoundationView.previewLayer)
                                .onAppear {
                                    print("portrait")
                                    //self.orientation.addObserver()
                                }.onDisappear {
                                    //self.orientation.removeObserver()
                                }

                            HStack {
                                Button(action: {
                                    self.avFoundationView.takePhoto()
                                }) {
                                    Image(systemName: "camera.circle.fill")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 80, height: 80, alignment: .center)
                                        .foregroundColor(.white)
                                        .background(Color.gray.opacity(0))
                                }
                                
                            }
                            .padding(.bottom, 50.0)
                            Spacer()
                        }
                        
                    }
                    else  {
                        HStack {
                            LandscapeCALayerView(caLayer: avFoundationView.previewLayer)
                                .onAppear {
                                    print("landscape")
                                    //self.orientation.addObserver()
                                }.onDisappear {
                                    //self.orientation.removeObserver()
                                }

                            HStack {
                                Button(action: {
                                    self.avFoundationView.takePhoto()
                                }) {
                                    Image(systemName: "camera.circle.fill")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 80, height: 80, alignment: .center)
                                        .foregroundColor(.white)
                                        .background(Color.gray.opacity(0))
                                }
                                
                            }
                            .padding(.leading, 50.0)
                            Spacer()
                        }
                        
                        
                    }
                }
                
                
                

            }
            else {
                if current_orientation.isPortrait {
                    VStack {
                        ZStack(alignment: .topLeading) {
                            VStack {
                                Spacer()
                                Image(uiImage: avFoundationView.image!)
                                    .resizable()
                                    .scaledToFill()
                                    .aspectRatio(contentMode: .fit)
                                Spacer()
                            }
                            Button(action: {
                                self.avFoundationView.image = nil
                            }) {
                                Image(systemName: "xmark.circle")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.gray.opacity(0))
                            }
                                .frame(width: 80, height: 80, alignment: .center)
                        }
                        ZStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    ImageSaver($showAlert).writeToPhotoAlbum(image: avFoundationView.image!)
                                }) {
                                    Image(systemName: "square.and.arrow.down")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 80, height: 80, alignment: .center)
                                        .foregroundColor(.white)
                                        .background(Color.gray.opacity(0))
                                    }
                                .padding(.bottom, 50.0)
                                .alert(isPresented: $showAlert) {
                                        Alert(
                                            title: Text("画像を保存しました。"),
                                            message: Text(""),
                                            dismissButton: .default(Text("OK"), action: {
                                                showAlert = false
                                            }))
                                    }
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    ImageSaver($showAlert).writeToPhotoAlbum(image: avFoundationView.image!)
                                    openURL(URL(string: "https://twitter.com/intent/tweet?text=%23mis1yakudo")!)
                                }) {
                                    Image("twitter")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .background(Color.gray.opacity(0))
                                }
                                .padding(.bottom, 70.0)
                                .padding(.trailing, 40.0)
                            }
                            
                        }
                        .onAppear() {
                            previous_orientation = current_orientation
                        }
                    }
                    }
                    else if current_orientation.isLandscape {
                        HStack {
                            ZStack(alignment: .topLeading) {
                                VStack {
                                    Spacer()
                                    Image(uiImage: avFoundationView.image!)
                                    .resizable()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    Spacer()
                                }
                                Button(action: {
                                    self.avFoundationView.image = nil
                                }) {
                                    Image(systemName: "xmark.circle")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 30, height: 30, alignment: .center)
                                        .foregroundColor(.white)
                                        .background(Color.gray.opacity(0))
                                }
                                    .frame(width: 50, height: 50, alignment: .center)
                            }
                            ZStack {
                                VStack {
                                    Spacer()
                                    Button(action: {
                                        ImageSaver($showAlert).writeToPhotoAlbum(image: avFoundationView.image!)
                                    }) {
                                        Image(systemName: "square.and.arrow.down")
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 80, height: 80, alignment: .center)
                                            .foregroundColor(.white)
                                            .background(Color.gray.opacity(0))
                                        }.alert(isPresented: $showAlert) {
                                            Alert(
                                                title: Text("画像を保存しました。"),
                                                message: Text(""),
                                                dismissButton: .default(Text("OK"), action: {
                                                    showAlert = false
                                                }))
                                        }
                                    Spacer()
                                }
                                VStack {
                                    Spacer()
                                    Button(action: {
                                        ImageSaver($showAlert).writeToPhotoAlbum(image: avFoundationView.image!)
                                        openURL(URL(string: "https://twitter.com/intent/tweet?text=%23mis1yakudo")!)
                                    }) {
                                        Image("twitter")
                                            .renderingMode(.original)
                                            .resizable()
                                            .frame(width: 50, height: 50, alignment: .center)
                                            .background(Color.gray.opacity(0))
                                    }
                                    .padding(.bottom, 20.0)
                                }
                            }
                        }
                        .onAppear() {
                            previous_orientation = current_orientation
                        }
                        
                    }
                    else {
                        if previous_orientation.isPortrait {
                            VStack {
                                ZStack(alignment: .topLeading) {
                                    VStack {
                                        Spacer()
                                        Image(uiImage: avFoundationView.image!)
                                            .resizable()
                                            .scaledToFill()
                                            .aspectRatio(contentMode: .fit)
                                        Spacer()
                                    }
                                    Button(action: {
                                        self.avFoundationView.image = nil
                                    }) {
                                        Image(systemName: "xmark.circle")
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .center)
                                            .foregroundColor(.white)
                                            .background(Color.gray.opacity(0))
                                    }
                                        .frame(width: 80, height: 80, alignment: .center)
                                }
                                
                                ZStack {
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            ImageSaver($showAlert).writeToPhotoAlbum(image: avFoundationView.image!)
                                        }) {
                                            Image(systemName: "square.and.arrow.down")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 80, height: 80, alignment: .center)
                                                .foregroundColor(.white)
                                                .background(Color.gray.opacity(0))
                                            }
                                        .padding(.bottom, 50.0)
                                        .alert(isPresented: $showAlert) {
                                                Alert(
                                                    title: Text("画像を保存しました。"),
                                                    message: Text(""),
                                                    dismissButton: .default(Text("OK"), action: {
                                                        showAlert = false
                                                    }))
                                            }
                                        Spacer()
                                    }
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            ImageSaver($showAlert).writeToPhotoAlbum(image: avFoundationView.image!)
                                            openURL(URL(string: "https://twitter.com/intent/tweet?text=%23mis1yakudo")!)
                                        }) {
                                            Image("twitter")
                                                .renderingMode(.original)
                                                .resizable()
                                                .frame(width: 50, height: 50, alignment: .center)
                                                .background(Color.gray.opacity(0))
                                        }
                                        .padding(.bottom, 70.0)
                                        .padding(.trailing, 40.0)
                                    }
                                }
                            }
                        }
                        else  {
                            HStack {
                                ZStack(alignment: .topLeading) {
                                    VStack {
                                        Spacer()
                                        Image(uiImage: avFoundationView.image!)
                                        .resizable()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        Spacer()
                                    }
                                    Button(action: {
                                        self.avFoundationView.image = nil
                                    }) {
                                        Image(systemName: "xmark.circle")
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .center)
                                            .foregroundColor(.white)
                                            .background(Color.gray.opacity(0))
                                    }
                                        .frame(width: 50, height: 50, alignment: .center)
                                }
                                
                                ZStack {
                                    VStack {
                                        Spacer()
                                        Button(action: {
                                            ImageSaver($showAlert).writeToPhotoAlbum(image: avFoundationView.image!)
                                        }) {
                                            Image(systemName: "square.and.arrow.down")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 80, height: 80, alignment: .center)
                                                .foregroundColor(.white)
                                                .background(Color.gray.opacity(0))
                                            }.alert(isPresented: $showAlert) {
                                                Alert(
                                                    title: Text("画像を保存しました。"),
                                                    message: Text(""),
                                                    dismissButton: .default(Text("OK"), action: {
                                                        showAlert = false
                                                    }))
                                            }
                                        Spacer()
                                    }
                                    VStack {
                                        Spacer()
                                        Button(action: {
                                            ImageSaver($showAlert).writeToPhotoAlbum(image: avFoundationView.image!)
                                            openURL(URL(string: "https://twitter.com/intent/tweet?text=%23mis1yakudo")!)
                                        }) {
                                            Image("twitter")
                                                .renderingMode(.original)
                                                .resizable()
                                                .frame(width: 50, height: 50, alignment: .center)
                                                .background(Color.gray.opacity(0))
                                        }
                                        .padding(.bottom, 20.0)
                                    }
                                }
                            }
                        }
                    }
                }
            
                
            
            
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name(UIDevice.orientationDidChangeNotification.rawValue)), perform: { _ in
                avFoundationView.updatePreviewOrientation()
                current_orientation = UIDevice.current.orientation
                //print(current_orientation.isLandscape)
            })
            .onAppear {
               self.avFoundationView.startSession()
                avFoundationView.updatePreviewOrientation()
                current_orientation = UIDevice.current.orientation
                //self.orientation.addObserver()
            }.onDisappear {
                self.avFoundationView.endSession()
                //self.orientation.removeObserver()
            }
            .sheet(isPresented: $inPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $avFoundationView.image)
               
                
            }
        }
    
        func saveYakudo() {
            
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

