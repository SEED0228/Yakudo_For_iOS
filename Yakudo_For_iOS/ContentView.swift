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
    @State var expansionRate:CGFloat = 1.0
    @State var insets = 0.0
    @Environment(\.openURL) var openURL

    init() {
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
                            .gesture(MagnificationGesture()
                                .onChanged { value in
                                    self.avFoundationView.zoomCamera(value: value)
                                 }
                                .onEnded { value in
                                    self.avFoundationView.zoomEnded()
                                    self.expansionRate = self.avFoundationView.expansionRate
                                }
                                     )
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
                        .padding(.leading, 40.0  - self.insets * 1.5)
                        Spacer()
                        VStack {
                            if expansionRate > 1.0 {
                                Text(String(format: "x%.1f", self.expansionRate))
                                    .padding(.top, 30.0)
                                    .padding(.trailing, 70.0 - self.insets * 3.5)
                            }
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
                            .padding(.trailing, 70.0 - self.insets * 3.5)
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
                            .padding(.leading, 55.0 - self.insets * 1.5)
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
                            .gesture(MagnificationGesture()
                                .onChanged { value in
                                    self.avFoundationView.zoomCamera(value: value)
                                 }
                                .onEnded { value in
                                    self.avFoundationView.zoomEnded()
                                    self.expansionRate = self.avFoundationView.expansionRate
                                }
                                     )
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
                            .padding(.leading, 70.0 - self.insets * 3.5)
                            Spacer()
                            if expansionRate > 1.0 {
                                Text(String(format: "x%.1f", self.expansionRate))
                                    .padding(.bottom, 30.0)
                                    .padding(.leading, 70.0 - self.insets * 3.5)
                            }
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
                        .padding(.trailing, 40.0 - self.insets * 1.5)
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
                            .padding(.trailing, 55.0  - self.insets * 1.5)
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
                        .gesture(MagnificationGesture()
                            .onChanged { value in
                                self.avFoundationView.zoomCamera(value: value)
                             }
                            .onEnded { value in
                                self.avFoundationView.zoomEnded()
                                self.expansionRate = self.avFoundationView.expansionRate
                            }
                                 )
                    }
                    VStack {
                        HStack {
                            if expansionRate > 1.0 {
                                Text(String(format: "x%.1f", self.expansionRate))
                                    .padding(.top, 70.0 - self.insets * 3.5)
                                    .padding(.leading, 30.0)
                            }
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
                            .padding(.top, 70.0 - self.insets * 3.5)
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
                        .padding(.bottom, 50.0 - self.insets * 1.5)
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
                        .padding(40.0 - self.insets * 1.0)
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
                                .padding(.trailing, 75.0 - self.insets * 2.0)
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
                                    .padding(.trailing, 75.0  - self.insets * 2.0)
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
                                .padding(.bottom, 75.0  - self.insets * 2.0)
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
                                    .padding(.bottom, 75.0  - self.insets * 2.0)
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
        })
        .onAppear {
           self.avFoundationView.startSession()
            avFoundationView.updatePreviewOrientation()
            current_orientation = UIDevice.current.orientation
            previous_orientation = UIDevice.current.orientation
            var safeAreaInsets = max(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0)
            safeAreaInsets = max(safeAreaInsets, UIApplication.shared.windows.first?.safeAreaInsets.left ?? 0.0, UIApplication.shared.windows.first?.safeAreaInsets.right ?? 0.0)
             // ノッチがない場合の処理
             if(safeAreaInsets < 44.0){
                 self.insets = 10.0
             }
        }
        .onDisappear {
            self.avFoundationView.endSession()
        }
        .edgesIgnoringSafeArea(.all)
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

