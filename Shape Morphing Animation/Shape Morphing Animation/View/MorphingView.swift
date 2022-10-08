//
//  MorphingView.swift
//  Shape Morphing Animation
//
//  Created by Dalveer singh on 08/10/22.
//

import SwiftUI

struct MorphingView: View {
    @State var currentImage:CustomeShape = .cloud
    @State var pickerImage:CustomeShape = .cloud
    @State var turnOffMorph = true
    @State var animateMorph = false
    @State var blurRadius:CGFloat = 0
    var body: some View {
        //        MARK: Morphing shapes with the help of canvas and filters
        
        VStack{
            GeometryReader{
                proxy in
                let size = proxy.size
                Image("tim")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(x: 50, y: 50)
                    .frame(width:size.width,height: size.height)
                    .clipped()
                    .overlay(
                        Rectangle().opacity(turnOffMorph ? 0 :  1)
                    )
                    .mask {
                        Canvas{
                            context,size in
//                            MARK: Morphing Filter
                            context.addFilter(.alphaThreshold(min: 0.3))
//                           MARK: Below value is important
                            context.addFilter(.blur(radius: blurRadius>=20 ? 20 - (blurRadius-20) : blurRadius))
                            //Draw image Inside the layer
                            context.drawLayer { ctx in
                                if let resolvedImage = context.resolveSymbol(id: 1){
                                    ctx.draw(resolvedImage,at: CGPoint(x: size.width/2, y: size.height/2),anchor: .center)

                            }
                            
                            }
                        } symbols: {
                           
                            //                    MARK: Giving images with ID
                            
                            ResolvedImage(currentImage: $currentImage)
                                .tag(1)
                        }
                        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
//                            print(time)
                            if animateMorph{
                                if blurRadius <= 40{
                                    blurRadius+=0.5
                                    if blurRadius.rounded() == 20{
                                        // Change to next image
                                        currentImage = pickerImage
                                    }
                                }
                                if blurRadius.rounded() == 40{
                                    // End the animation and reset the blur to zero
                                    animateMorph = false
                                    blurRadius = 0
                                    
                                }
                            }
                            

                            }
                        }
            }
            
            .frame(height:400)
            //            MARK: Segmented Picker
            Picker("", selection: $pickerImage) {
                ForEach(CustomeShape.allCases,id:\.rawValue)
                {
                    shape in
                    Image(systemName: shape.rawValue)
                        .tag(shape)
                }
            }
            .overlay(content: {
                Rectangle()
                    .fill(.primary)
                    .opacity(animateMorph ? 0.05:0)
            })
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: pickerImage) { newValue in
                animateMorph = true
            }
            Toggle("Turn Off Morph",isOn: $turnOffMorph)
                .padding(.horizontal,15)
                .padding(.top,10)
            Spacer()
        }
    }
}

struct ResolvedImage:View{
    @Binding var currentImage:CustomeShape
    var body: some View{
        Image(systemName: currentImage.rawValue)
            .font(.system(size: 200))
            .animation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8), value: currentImage)
            .frame(width:300,height: 300)
        
    }
}

struct MorphingView_Previews: PreviewProvider {
    static var previews: some View {
        MorphingView()
    }
}
