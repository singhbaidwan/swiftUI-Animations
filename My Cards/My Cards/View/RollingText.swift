//
//  RollingText.swift
//  My Cards
//
//  Created by Dalveer singh on 25/12/22.
//

import SwiftUI

struct RollingText: View {
    var font:Font = .largeTitle
    var weight:Font.Weight = .regular
    @Binding var value:Int
    var animationDuration:CGFloat = 0.15
    //MARK: Animation Properties
    @State var animationRange:[Int] = []
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<animationRange.count,id: \.self){ index in
                
                Text("0")
                    .font(font)
                    .fontWeight(weight)
                    .opacity(0)
                    .overlay {
                        GeometryReader{ proxy in
                            let size = proxy.size
                            VStack(spacing:0)
                            {
                                ForEach(0...9,id:\.self){ number in
                                    Text("\(number)")
                                        .font(font)
                                        .fontWeight(weight)
                                        .frame(width: size.width, height: size.height, alignment:.center )
                                }
                            }
                            .offset(y: -CGFloat(animationRange[index]) * size.height)
                        }
                        .clipped()
                    }
                
            }
        }
        .onAppear{
            animationRange = Array(repeating: 0, count: "\(value)".count)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.06, execute: {
                updateText()
            })
        }
        .onChange(of: value) { newValue in
            // MARK: handling addition removal to extra value
            let extra = "\(value)".count - animationRange.count
            if extra > 0{
                // Adding Extra Range
                for _ in 0..<extra{
                    withAnimation(.easeIn(duration: 0.1)){animationRange.append(0)}
                }
            }
            else
            {
                // Removing Extra Range
                for _ in 0..<(-extra)
                {
                   let _ =  withAnimation(.easeIn(duration: 0.1)){animationRange.removeLast()}
                }
            }
            
            //Adding little delay
            DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
                updateText()
            })
        }
    }
    func updateText(){
        let stringValue = "\(value)"
        for (index,value) in zip(0..<stringValue.count, stringValue){
            // if first value = 1 , then offset applied is -1 so text value will move up to show 1 value
            //MARK: Damping based on index values
            var fraction = Double(index)*0.15
            fraction = (fraction > 0.5 ? 0.5 : fraction)
            withAnimation(.interactiveSpring(response: animationDuration, dampingFraction: 1+fraction, blendDuration: 1+fraction))
            {
                animationRange[index] = (String(value) as NSString).integerValue
            }
        }
    }
}

struct RollingText_Previews: PreviewProvider {
    static var previews: some View {
        RollingText(value: .constant(972))
    }
}
