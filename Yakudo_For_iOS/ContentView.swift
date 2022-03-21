//
//  ContentView.swift
//  Yakudo_For_iOS
//
//  Created by SEED on 2021/04/20.
//

import SwiftUI

struct ContentView: View {
    @State var image: UIImage?
    @State var processing = false
    @State var isFrontCamera = false
    @State var isSelecting = false
    @State var yakudoImage: UIImage? = UIImage()
    @ObservedObject private var avFoundationView = AVFoundationView()
    @ObservedObject private var orientation:OrientationObserver = OrientationObserver()
    @State var current_orientation: UIDeviceOrientation = .portrait
    @State var previous_orientation: UIDeviceOrientation = .portrait
    @State var showAlert = false
    @State private var isTweeting = false
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
    
    func takePhoto() {
        avFoundationView.takePhoto(previousOriantation: UIDevice.current.orientation == .portraitUpsideDown ? .portraitUpsideDown : previous_orientation)
    }
    
    func reverseCamera() {
        isFrontCamera.toggle()
        processing = true
        self.avFoundationView.prepareCamera(withPosition: isFrontCamera ? .front : .back)
        self.avFoundationView.beginSession(deviceOrientation: previous_orientation)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            processing = false
        }
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
                .sheet(isPresented: $isSelecting) {
                    ImagePicker(selectedImage: $image)
                }
                .onChange(of: self.image) { image in
                    if image != nil {
                        let orientation = image!.imageOrientation
                        let yakudoImage = UIImage(cgImage: (Yakudo.yakudo(image)!).cgImage!, scale: 0, orientation: orientation)
                        self.avFoundationView.image = yakudoImage
                        self.image = nil
                    }
                }
                
            if avFoundationView.image == nil {
                if current_orientation == .landscapeRight || (current_orientation.isFlat && previous_orientation == .landscapeRight) || (current_orientation == .portraitUpsideDown && previous_orientation == .landscapeRight) {
                    if !processing {
                        HStack {
                            LandscapeRightCALayerView(caLayer: avFoundationView.previewLayer)
                            .onAppear {
                                print("landscape right")
                                previous_orientation = .landscapeRight
                            }
                            Spacer()
                        }
                    }
                    HStack {
                        Button(action: {
                            self.takePhoto()
                        }) {
                            Image(systemName: "camera.circle.fill")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .center)
                                .foregroundColor(.white)
                                .background(Color.gray.opacity(0))
                        }
                        .padding(.leading, 40.0)
                        Spacer()
                        VStack {
                            Spacer()
                            Button(action: {
                                self.reverseCamera()
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 40, height: 30, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.gray.opacity(0))
                            }
                            .padding(.bottom, 30.0)
                        }
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                self.isSelecting = true
                            }) {
                                Image(systemName: "photo")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.gray.opacity(0))
                            }
                            .padding(.leading, 55.0)
                            Spacer()
                        }
                        .padding(.bottom, 30.0)
                    }
                }
                else if current_orientation == .landscapeLeft || (current_orientation.isFlat && previous_orientation == .landscapeLeft) || (current_orientation == .portraitUpsideDown && previous_orientation == .landscapeLeft)  {
                    if !processing {
                        HStack {
                            LandscapeLeftCALayerView(caLayer: avFoundationView.previewLayer)
                            .onAppear {
                                print("landscape left")
                                previous_orientation = .landscapeLeft
                            }
                            Spacer()
                        }
                    }
                    HStack {
                        VStack {
                            Button(action: {
                                self.reverseCamera()
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 40, height: 30, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.gray.opacity(0))
                            }
                            .padding(.top, 30.0)
                            Spacer()
                        }
                        Spacer()
                        Button(action: {
                            self.takePhoto()
                        }) {
                            Image(systemName: "camera.circle.fill")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .center)
                                .foregroundColor(.white)
                                .background(Color.gray.opacity(0))
                        }
                        .padding(.trailing, 40.0)
                    }
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.isSelecting = true
                            }) {
                                Image(systemName: "photo")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.gray.opacity(0))
                            }
                            .padding(.trailing, 55.0)
                        }
                        .padding(.top, 30.0)
                        Spacer()
                    }
                }
                else {
                    if !processing {
                        PortraitCALayerView(caLayer: avFoundationView.previewLayer)
                        .onAppear {
                            print("portrait")
                            previous_orientation = .portrait
                        }
                    }
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.reverseCamera()
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 40, height: 30, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.gray.opacity(0))
                            }
                            .padding(.trailing, 30.0)
                        }
                        Spacer()
                        ZStack {
                            Button(action: {
                                self.takePhoto()
                            }) {
                                Image(systemName: "camera.circle.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.gray.opacity(0))
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.isSelecting = true
                                }) {
                                    Image(systemName: "photo")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .foregroundColor(.white)
                                        .background(Color.gray.opacity(0))
                                }
                                .padding(.trailing, 30.0)
                            }
                        }
                        .padding(.bottom, 50.0)
                    }
                    
                }
                if processing {
                    Color.init(.sRGB, red: 1.0, green: 1.0, blue: 1.0, opacity: 0.6)
                        .edgesIgnoringSafeArea(.all)
                    ActivityIndicator(isAnimating: $processing, style: .large)
                }
            }
            else {
                Image(uiImage: avFoundationView.image!)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fit)
                VStack {
                    HStack {
                        Button(action: {
                            self.avFoundationView.image = nil
                        }) {
                            Image(systemName: "xmark.circle")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                                .foregroundColor(.white)
                                .background(Color.gray.opacity(0))
                        }
                        .padding(30.0)
                        Spacer()
                    }
                    Spacer()
                }
                if current_orientation == .landscapeLeft || (current_orientation.isFlat && previous_orientation == .landscapeLeft) || (current_orientation == .portraitUpsideDown && previous_orientation == .landscapeLeft) || current_orientation == .landscapeRight || (current_orientation.isFlat && previous_orientation == .landscapeRight) || (current_orientation == .portraitUpsideDown && previous_orientation == .landscapeRight) {
                    HStack {
                        Spacer()
                        Button(action: {
                            ImageSaver($showAlert).writeToPhotoAlbum(image: avFoundationView.image!)
                        }) {
                            Image(systemName: "square.and.arrow.down")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                                .foregroundColor(.white)
                                .background(Color.gray.opacity(0))
                                .padding(.trailing, 55.0)
                            }.alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("画像を保存しました。"),
                                    message: Text(""),
                                    dismissButton: .default(Text("OK"), action: {
                                        showAlert = false
                                    }))
                            }
                            .onAppear {
                                print("landscape")
                                previous_orientation = .landscapeLeft
                            }
                        
                    }
                    HStack {
                        Spacer()
                        VStack {
                            Button(action: {
                                ImageSaver($isTweeting).writeToPhotoAlbum(image: avFoundationView.image!)
                                openURL(URL(string: "https://twitter.com/intent/tweet?text=%23mis1yakudo")!)
                            }) {
                                Image("twitter")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .background(Color.gray.opacity(0))
                                    .padding(.trailing, 55.0)
                                    .padding(.top, 55.0)
                            }
                            Spacer()
                        }
                    }
                }
                else {
                    VStack {
                        Spacer()
                        Button(action: {
                            ImageSaver($showAlert).writeToPhotoAlbum(image: avFoundationView.image!)
                        })
                        {
                            Image(systemName: "square.and.arrow.down")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                                .foregroundColor(.white)
                                .background(Color.gray.opacity(0))
                                .padding(.bottom, 55.0)
                        }.alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("画像を保存しました。"),
                                message: Text(""),
                                dismissButton: .default(Text("OK"), action: {
                                    showAlert = false
                                }))
                        }
                        .onAppear {
                            print("landscape portrait")
                            previous_orientation = .portrait
                        }
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                ImageSaver($isTweeting).writeToPhotoAlbum(image: avFoundationView.image!)
                                openURL(URL(string: "https://twitter.com/intent/tweet?text=%23mis1yakudo")!)
                            }) {
                                Image("twitter")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .background(Color.gray.opacity(0))
                                    .padding(.bottom, 55.0)
                                    .padding(.trailing, 55.0)
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
        }
    
        func saveYakudo() {
            
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool

    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

