//
//  ContentView.swift
//  MetalBall Animations
//
//  Created by Dalveer singh on 09/10/22.
//

import SwiftUI

struct ContentView: View {
    @State var dragOffset:CGSize = .zero
    @State var startAnimate:Bool = true
    @State var type:String = "Single"
    var body: some View {
        VStack{
            Text("Metal Ball Animation")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth:.infinity,alignment: .leading)
                .padding(15)
            Picker(selection: $type) {
                Text("MetalBall")
                    .tag("Single")
                Text("Clubbed")
                    .tag("Clubbed")
            }label:{}
                .pickerStyle(.segmented)
                .padding(.horizontal,15)
            if type=="Single"
            {
                singleMetalBall()
            }
            else{
                ClubbedView()
                
            }
        }
    }
    
    //    MARK: Clubbed One
    @ViewBuilder
    func ClubbedView()->some View{
        Rectangle()
            .fill(.linearGradient(colors:[Color(.orange),Color(.yellow).opacity(0.7)], startPoint: .top, endPoint: .bottom))
            .mask{
                //IT is the same view with addition of timeline to animate
                TimelineView(.animation(minimumInterval: 3.6, paused: false)){
                    time in
                    Canvas{ context,size in
                        //adding the filters
                        context.addFilter(.alphaThreshold(min: 0.5,color: .orange))
                        //blur radius determine the elasticity between two elements
                        context.addFilter(.blur(radius: 40))
                        // Drawing Layer
                        context.drawLayer { ctx in
                            
                            for index in 1..<15{
                                if let resolvedView = context.resolveSymbol(id: index)
                                {
                                    ctx.draw (resolvedView,at: CGPoint(x: size.width/2, y: size.height/2))
                                }
                            }
                        }
                        
                    }symbols: {
                        ForEach(0..<15,id:\.self)
                        {
                            index in
                            //Generating Custom Offset for each shapes thus it will be at random place and will be clubbed together
                            let offset = (startAnimate ? CGSize(width: .random(in: -180...180), height: .random(in: -240...240 )) : .zero)
                            clubbedRoundedRectangle(offset: offset)
                                .tag(index )
                        }
                    }
                    
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    startAnimate.toggle()
                }
            }
    }
    @ViewBuilder
    func clubbedRoundedRectangle(offset:CGSize)->some View{
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(.white)
            .frame(width: 120, height: 120)
            .offset(offset)
        //Adding Animation less than timeline view refresh period
            .animation(.easeInOut(duration: 4), value: offset)
    }
    
    
    //    MARK: Single Metal Ball Animation
    @ViewBuilder
    func singleMetalBall()->some View{
        Rectangle()
            .fill(.linearGradient(colors:[Color(.orange),Color(.yellow).opacity(0.7)], startPoint: .top, endPoint: .bottom))
            .mask {
                Canvas{ context,size in
                    //adding the filters
                    context.addFilter(.alphaThreshold(min: 0.5,color: .orange))
                    //blur radius determine the elasticity between two elements
                    context.addFilter(.blur(radius: 40))
                    // Drawing Layer
                    context.drawLayer { ctx in
                        
                        for index in [1,2]{
                            if let resolvedView = context.resolveSymbol(id: index)
                            {
                                ctx.draw (resolvedView,at: CGPoint(x: size.width/2, y: size.height/2))
                            }
                        }
                    }
                    
                }symbols: {
                    Ball()
                        .tag(1)
                    Ball(offset: dragOffset)
                        .tag(2)
                }
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            dragOffset = value.translation
                        })
                        .onEnded({ _ in
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                                dragOffset = .zero
                            }
                        })
                )
            }
        
    }
    @ViewBuilder
    func Ball(offset:CGSize = .zero)->some View{
        Circle()
            .fill(.white)
            .frame(width:150,height: 150)
            .offset(offset)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
