//
//  DSPObject.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

public struct DSPConfiguration {
    public var sampleRate: Float
    public var blockSize: Int
}
// MARK: -

public protocol DSPInspectable {
    var allInputs: [UnsafePointer<Float>] { get }
    var allOutputs: [UnsafeMutablePointer<Float>] { get }
}

public protocol DSPObject : DSPInspectable {
    func process()
    var configuration: DSPConfiguration { get set }

    var build: DSPObject { get }

}

// MARK: -

extension DSPInspectable {
    public var allInputs: [UnsafePointer<Float>] {
        Mirror(reflecting: self).children.compactMap { child in
            if let input = child.value as? AudioIn {
                return input.wrappedValue
            }
            return nil
        }
    }

    public var allOutputs: [UnsafeMutablePointer<Float>] {
        Mirror(reflecting: self).children.compactMap { child in
            if let output = child.value as? AudioOut {
                return output.wrappedValue
            }
            return nil
        }
    }
}

public protocol DSPIOComponent {}

// MARK: -
 
/*
 struct INode;

 using AnyNode = INode *;
 using NodeVec = std::vector<INode *>;

 using BuildAnyNodeFn = std::function<AnyNode(void)>;
 using BuildVectorFn = std::function<NodeVec(void)>;

 struct INode
 {
     virtual ~INode() {}

     virtual Configuration prepare(const Configuration cfg, const double sampleRate) = 0;

     virtual void process(const Buffer &ins, Buffer &outs) = 0;
 };

 // MARK: - type erasure optimizations

 struct CompiledNode {
     void * ctx;
     void(*prepareFn)(void* ctx, Configuration&, double);
     void(*performFn)(void* ctx, Buffer&, Buffer&);
 };

 class BuildFn {
     BuildAnyNodeFn _erased;
     
 public:
     void(*prepareFn)(void* ctx, Configuration&, double);
     void(*performFn)(void* ctx, Buffer&, Buffer&);
     
     BuildFn (BuildAnyNodeFn b = +[]()->AnyNode { return nullptr; }){
         _erased = std::move(b);
         
         prepareFn = +[](void* ctx, Configuration& cfg, double sampleRate){  ((INode*)ctx)->prepare(cfg, sampleRate); };
         performFn = +[](void* ctx, Buffer& ins, Buffer& outs){  ((INode*)ctx)->process( ins, outs); };
     }
     
     BuildFn(const BuildFn&) = default;
     BuildFn(BuildFn&&) = default;
     
     BuildFn& operator=(const BuildFn&) = default;
     BuildFn& operator=(BuildFn&&) = default;

     template <typename F,
                   typename T = typename std::invoke_result<F>::type,
                   typename = std::enable_if_t<std::is_base_of<INode, std::remove_pointer_t<T>>::value>>
         BuildFn(F fn) {
             _erased = [fn]() -> AnyNode {
                 return static_cast<AnyNode>(fn());
             };
             prepareFn = [](void* ctx, Configuration& cfg, double sr) {
                 static_cast<T>(ctx)->prepare(cfg, sr);
             };
             performFn = [](void* ctx, Buffer& ins, Buffer& outs) {
                 static_cast<T>(ctx)->process(ins, outs);
             };
         }
     
     AnyNode operator()(){ return _erased(); }
     AnyNode operator()() const { return _erased(); }
     
     // unsafe call - ptr should be a result of this operator()
     CompiledNode compile(void* ptr) {
         return CompiledNode{.ctx = ptr, .prepareFn = prepareFn, .performFn = performFn };
     }
 };


 // MARK: - macros

 #define ƒ(...) [&]() -> AnyNode { return __VA_ARGS__; }
 #define ƒVec(...) [&]() -> NodeVec { return {__VA_ARGS__}; }

 #define ƒLambda(...) ƒ(new NodeLambda{__VA_ARGS__})
 //#define ƒLambdaCh(outs, ...) ƒ(new NodeLambda(outs){__VA_ARGS__})

 // MARK: - macros / builders

 template <typename T, typename... Args>
 auto µ(Args&&... args) {
     static_assert(std::is_base_of_v<INode, T>, "T must inherit from INode");

     return [&]() -> INode* {
         return new T(args...);
     };
 }

 template <typename... Builders>
 auto µ(Builders&&... builders) {
     static_assert((std::is_invocable_r_v<INode*, Builders> && ...),
                   "All arguments must be callable and return INode*");

     return [=]() -> std::vector<INode*> {
         return { builders()... };
     };
 }

 // MARK: - builders

 struct BuildNode
 {
     BuildFn builder{};
     std::unique_ptr<INode> node{};

     BuildNode(BuildFn f = BuildFn { +[]()->AnyNode { return nullptr; }})
     {
         builder = f;
         init();
     }

 private:
     void init() { node.reset(builder()); }
 };

 struct BuildNodeVec
 {
     BuildVectorFn builder{+[] { return NodeVec{}; }};
     std::vector<std::unique_ptr<INode>> vec{};

     BuildNodeVec(BuildVectorFn f = +[] { return NodeVec{}; })
     {
         builder = f;
         init();
     }

 private:
     void init()
     {
         auto result = builder();
         vec.resize(result.size());
         for (int i = 0; i < vec.size(); i++)
             vec[i].reset(result[i]);
     }
 };

 // MARK: -

 template<typename FUNC>
 struct NodeLambda : public INode
 {
     FUNC _func;

     long _outCh{-1};
     NodeLambda(FUNC f, size_t ch = -1)
         : _func(f)
     {
         _outCh = ch;
     }

     virtual Configuration prepare(const Configuration cfg, const double sampleRate) override
     {
         return {_outCh < 0 ? cfg
                            : Configuration{.channels = (size_t) _outCh, .samples = cfg.samples}};
     }
     virtual void process(const Buffer &ins, Buffer &out) override { _func(ins, out); }
 };
 */
