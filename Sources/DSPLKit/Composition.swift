//
//  Parallel.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//


public struct Parallel: DSPObject {
    public var build: any DSPObject
    
//    public static func build() -> any DSPObject {
//        
//    }
    
    public var configuration: DSPConfiguration
    
    var left: DSPObject
    var right: DSPObject
    
    public func process() {
        left.process()
        right.process()
    }
}

public struct Sequential: DSPObject {
    public var build: any DSPObject
    
//    public static func build() -> any DSPObject {
//        
//    }
    
    public var configuration: DSPConfiguration
    
    var first: DSPObject
    var second: DSPObject
    
    public func process() {
        first.process()
        second.process()
    }
}

// MARK: -

// E.g. feedback using ~ could be added as a circular buffer wrapper

public final class ParallelDSP: DSPInspectable {
    private let nodes: [DSPInspectable]

    public init(@DSPBuilder _ content: () -> [DSPInspectable]) {
        self.nodes = content()
        
        // TODO: connections
    }

    public func process() {
//        for node in nodes {
//            (node as? DSPNode)?.process()
//        }
    }

    public var allInputs: [UnsafePointer<Float>] {
        nodes.flatMap { $0.allInputs }
    }

    public var allOutputs: [UnsafeMutablePointer<Float>] {
        nodes.flatMap { $0.allOutputs }
    }
}

/*
 /// parallel composition
 struct Parallel : public INode
 {
     BuildNodeVec builder{};

     std::vector<Buffer> _outputs{};

     const std::vector<std::unique_ptr<INode>> &getElements() { return builder.vec; }

     Parallel(BuildVectorFn b = [] { return NodeVec{}; })
         : builder({b})
     {
         // builder.init();
         _outputs.resize(builder.vec.size());
     }

     virtual Configuration prepare(const Configuration cfg, const double sampleRate) override
     {
         size_t outChannels{0};
         for (int i = 0; i < builder.vec.size(); i++) {
             auto &e = builder.vec[i];

             auto lastCfg = e->prepare(cfg, sampleRate);
             outChannels += lastCfg.channels;

             ResizeBuffer(_outputs[i], lastCfg);
         }

         return {.channels = outChannels, .samples = cfg.samples};
     }

     void process(const Buffer &ins, Buffer &outs) override
     {
         for (int i = 0; i < builder.vec.size(); i++) {
             auto &e = builder.vec[i];

             // TEST
             FillBufferConst(_outputs[i], 0);
             e->process(ins, _outputs[i]);
         }

         int ch = 0;
         for (int i = 0; i < _outputs.size(); i++) {
             for (int j = 0; j < _outputs[i].size(); j++) {
                 assert(ch < outs.size());

                 assert(outs[ch].size() <= _outputs[i][j].size());

                 for (int s = 0; s < _outputs[i][j].size(); s++) {
                     outs[ch][s] = _outputs[i][j][s];
                     _outputs[i][j][s] = 0;
                 }
                 ch++;
             }
         }
     }
 };

 /// sequential composition
 struct Sequence : public INode
 {
     BuildNodeVec builder{};

     std::vector<Buffer> _outputs{};

     Sequence(BuildVectorFn b = [] { return NodeVec{}; })
         : builder({b})
     {
         // builder.init();
         _outputs.resize(builder.vec.size());
     }

     virtual Configuration prepare(const Configuration cfg, const double sampleRate) override
     {
         auto lastCfg = cfg;
         for (int i = 0; i < builder.vec.size(); i++) {
             auto &e = builder.vec[i];

             lastCfg = e->prepare(lastCfg, sampleRate);
             ResizeBuffer(_outputs[i], lastCfg);
         }

         return lastCfg;
     }

     void process(const Buffer &ins, Buffer &outs) override
     {
         auto currentBuffer = &ins;

         //
         FillBufferConst(outs, 0);

         for (int i = 0; i < builder.vec.size(); i++) {
             auto &e = builder.vec[i];

             FillBufferConst(_outputs[i], 0);

             e->process(*currentBuffer, _outputs[i]);

             currentBuffer = &_outputs[i];
         }
         CopyBuffer(outs, *currentBuffer);
     }
 };

 // MARK: -

 // TODO?
 struct ParallelMix : public INode {
     Buffer _output{};
     Parallel _layers{};
     
     BuildVectorFn _build { µ() };
     
     ParallelMix(BuildVectorFn build = µ()){
         _build = build;
         
         _layers = Parallel( [&]()->NodeVec {
             
             auto nodes = _build();
             
             NodeVec ret {};
             ret.reserve(nodes.size());
             
             for (int i=0;i<nodes.size();i++) {
                 auto& e = nodes[i];
                 bool isFirst = (i==0);
                 bool isLast = (i==nodes.size()-1);
                 
                 auto sequenceBuilder = µ([&]{ return e; }, ((isFirst) ? std::function<AnyNode()>(µ<WriteTo>(_output))
                                              : std::function<AnyNode()>(µ<AddTo>(_output))),
                                     ((isLast) ? std::function<AnyNode()>(µ<ReadFrom>(_output))
                                      : std::function<AnyNode()>(µ<Discard>())));
                 
                 ret.push_back(new Sequence(sequenceBuilder));
             }
             return ret;
         });
     }
     
     // forward
     virtual Configuration prepare(const Configuration cfg, const double sampleRate) { return _layers.prepare(cfg,sampleRate); }

     virtual void process(const Buffer &ins, Buffer &outs) { _layers.process(ins,outs); }
 };
 */
