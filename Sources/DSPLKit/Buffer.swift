//
//  Buffer.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 18/06/2025.
//

/*
 // NB: full input to buffer and output

 struct WriteTo : public INode
 {
     Buffer &buffer;

     WriteTo(Buffer &b)
         : buffer(b) {};

     virtual Configuration prepare(const Configuration cfg, const double sampleRate) override
     {
         //        ResizeBuffer(buffer,cfg);
         return cfg;
     }
     void process(const Buffer &ins, Buffer &outs) override
     {
         for (size_t ch = 0; ch < ins.size(); ch++)
             for (size_t i = 0; i < ins[ch].size(); i++) {
                 buffer[ch][i] = ins[ch][i];
             }
     }
 };

 struct AddTo : public INode
 {
     Buffer &buffer;
     AddTo(Buffer &b)
         : buffer(b) {};

     virtual Configuration prepare(const Configuration cfg, const double sampleRate) override
     {
         //        ResizeBuffer(buffer,cfg);
         return cfg;
     }
     void process(const Buffer &ins, Buffer &outs) override
     {
         for (size_t ch = 0; ch < ins.size(); ch++)
             for (size_t i = 0; i < ins[ch].size(); i++) {
                 buffer[ch][i] += ins[ch][i];
             }
     }
 };

 struct ReadFrom : public INode
 {
     Buffer &buffer;

     ReadFrom(Buffer &b)
         : buffer(b) {};

     virtual Configuration prepare(const Configuration cfg, const double sampleRate) override
     {
         //        ResizeBuffer(buffer,cfg);
         return cfg;
     }
     void process(const Buffer &ins, Buffer &outs) override
     {
         for (size_t ch = 0; ch < ins.size(); ch++)
             for (size_t i = 0; i < ins[ch].size(); i++) {
                 outs[ch][i] = buffer[ch][i];
             }
     }
 };

 // read parts
 struct ReadBlockFrom : public INode
 {
     Buffer &buffer;

     size_t _blockSize{512};
     size_t _readPtr{0};

     ReadBlockFrom(Buffer &b, const size_t bs = 512)
         : buffer(b)
         , _blockSize(bs) {};

     virtual Configuration prepare(const Configuration cfg, const double sampleRate) override
     {
         //        ResizeBuffer(buffer,{.channels = cfg.channels, .samples =
         //        _blockSize});
         return {.channels = cfg.channels, .samples = _blockSize};
     }

     void process(const Buffer &ins, Buffer &outs) override
     {
         if (ins.size() < 1)
             return;

         for (size_t i = 0; i < outs[0].size(); i++) {
             for (size_t ch = 0; ch < outs.size(); ch++) {
                 outs[ch][i] = buffer[ch][_readPtr];
                 // TEST
                 //                    buffer[ch][_readPtr] = 0;
             }

             _readPtr++;
             if (_readPtr >= buffer[0].size())
                 _readPtr = 0;
         }
     }
 };

 /// mostly a test object to clear buffer
 struct ClearBuffer : public INode
 {
     Buffer &buffer;

     ClearBuffer(Buffer &b)
         : buffer(b) {};

     virtual Configuration prepare(const Configuration cfg, const double sampleRate) override
     {
         ResizeBuffer(buffer, cfg);
         return cfg;
     }
     void process(const Buffer &ins, Buffer &outs) override
     {
         for (size_t ch = 0; ch < ins.size(); ch++)
             for (size_t i = 0; i < ins[ch].size(); i++) {
                 outs[ch][i] = ins[ch][i];
                 buffer[ch][i] = 0;
             }
     }
 };

 */
