//
//  Basic.swift
//  ObjeKit
//
//  Created by alex on 18/06/2025.
//

/*
 /// Constant value module
 struct Constant : public INode
 {
     Sample _value{};

     Constant(Sample v = 0.33) { _value = v; }
     virtual Configuration prepare(const Configuration cfg, const double sampleRate) override
     {
         return cfg;
     }

     void process(const Buffer &ins, Buffer &outs) override
     {
         for (auto ch = 0; ch < ins.size(); ch++)
             for (auto i = 0; i < ins[ch].size(); i++)
                 outs[ch][i] = _value;
     }
 };

 /// Add constant value
 struct AddConstant : public INode
 {
     Sample _value{};

     AddConstant(Sample v = 0.1) { _value = v; }
     virtual Configuration prepare(const Configuration cfg, const double sampleRate) override
     {
         return cfg;
     }

     void process(const Buffer &ins, Buffer &outs) override
     {
         for (auto ch = 0; ch < ins.size(); ch++)
             for (auto i = 0; i < ins[ch].size(); i++)
                 outs[ch][i] = ins[ch][i] + _value;
     }
 };

 /// Multiply by constant value
 struct MultiplyConstant : public INode
 {
     Sample _value{};

     MultiplyConstant(Sample v = 0.1) { _value = v; }
     virtual Configuration prepare(const Configuration cfg, const double sampleRate) override
     {
         return cfg;
     }

     void process(const Buffer &ins, Buffer &outs) override
     {
         for (auto ch = 0; ch < ins.size(); ch++)
             for (auto i = 0; i < ins[ch].size(); i++)
                 outs[ch][i] = ins[ch][i] + _value;
     }
 };

 // MARK: - special

 /// removes all outputs, no-op
 struct Discard : public INode
 {
     virtual Configuration prepare(const Configuration cfg, const double sampleRate) override
     {
         return {.channels = 0, .samples = cfg.samples};
     }
     virtual void process(const Buffer &ins, Buffer &out) override {}
 };

 // MARK: - buffer


 /// data -> output
 struct Copy : public INode
 {
     virtual Configuration prepare(const Configuration cfg, const double sampleRate) override
     {
         return cfg;
     }
     void process(const Buffer &ins, Buffer &outs) override
     {
         for (size_t ch = 0; ch < ins.size(); ch++)
             for (size_t i = 0; i < ins[ch].size(); i++) {
                 outs[ch][i] += ins[ch][i];
             }
     }
 };
 */
