/* Copyright (c) 2018 PaddlePaddle Authors. All Rights Reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License. */

import Foundation

struct Texture2DTo2DArrayParam {
    let input: MTLTexture
    let output: MTLTexture
    let expectDim: Dim
}

class Texture2DTo2DArrayKernel<P: PrecisionType>: Kernel, Computable{
    func compute(commandBuffer: MTLCommandBuffer, param: FeedParam<P>) throws {
        guard let encoder = commandBuffer.makeComputeCommandEncoder() else {
            throw PaddleMobileError.predictError(message: " encode is nil")
        }
        encoder.setTexture(param.input.mtlTexture, index: 0)
        encoder.setTexture(param.output.metalTexture, index: 1)
        encoder.dispatch(computePipline: pipline, outTexture: param.input.mtlTexture)
        encoder.endEncoding()
    }
    
    required init(device: MTLDevice, param: FeedParam<P>) {
        super.init(device: device, inFunctionName: "texture2d_to_2d_array")
    }
}
