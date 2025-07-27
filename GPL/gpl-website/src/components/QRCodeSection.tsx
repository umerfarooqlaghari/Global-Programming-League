'use client';

import { useEffect, useRef } from 'react';
import { Smartphone, Download, Star, ArrowRight } from 'lucide-react';
import QRCode from 'qrcode';

const QRCodeSection = () => {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    const generateQR = async () => {
      if (canvasRef.current) {
        try {
          // Using ICPS Google Play Store as placeholder
          const playStoreUrl = 'https://play.google.com/store/apps/details?id=com.facebook.katana';
          
          await QRCode.toCanvas(canvasRef.current, playStoreUrl, {
            width: 200,
            margin: 2,
            color: {
              dark: '#1A237E',
              light: '#FFFFFF'
            }
          });
        } catch (error) {
          console.error('Error generating QR code:', error);
        }
      }
    };

    generateQR();
  }, []);

  return (
    <section className="py-20 bg-gradient-to-br from-slate-50 to-blue-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          {/* Content Side */}
          <div>
            <div className="inline-flex items-center space-x-2 bg-blue-100 text-blue-800 px-4 py-2 rounded-full text-sm font-medium mb-6">
              <Smartphone className="w-4 h-4" />
              <span>Mobile App Available</span>
            </div>
            
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-6">
              Take GPL <span className="gradient-text">Anywhere</span>
            </h2>
            
            <p className="text-xl text-gray-600 mb-8 leading-relaxed">
              Download our mobile app and continue your competitive programming journey on the go. 
              Practice problems, participate in contests, and stay connected with the community from anywhere.
            </p>

            {/* Features List */}
            <div className="space-y-4 mb-8">
              <div className="flex items-center space-x-3">
                <div className="w-6 h-6 bg-green-100 rounded-full flex items-center justify-center">
                  <Star className="w-3 h-3 text-green-600" />
                </div>
                <span className="text-gray-700">Offline problem solving capability</span>
              </div>
              <div className="flex items-center space-x-3">
                <div className="w-6 h-6 bg-green-100 rounded-full flex items-center justify-center">
                  <Star className="w-3 h-3 text-green-600" />
                </div>
                <span className="text-gray-700">Real-time contest notifications</span>
              </div>
              <div className="flex items-center space-x-3">
                <div className="w-6 h-6 bg-green-100 rounded-full flex items-center justify-center">
                  <Star className="w-3 h-3 text-green-600" />
                </div>
                <span className="text-gray-700">Synchronized progress across devices</span>
              </div>
              <div className="flex items-center space-x-3">
                <div className="w-6 h-6 bg-green-100 rounded-full flex items-center justify-center">
                  <Star className="w-3 h-3 text-green-600" />
                </div>
                <span className="text-gray-700">Dark mode for comfortable coding</span>
              </div>
            </div>

            {/* Download Buttons */}
            <div className="flex flex-col sm:flex-row gap-4">
              <a
                href="https://play.google.com/store/apps/details?id=com.facebook.katana"
                target="_blank"
                rel="noopener noreferrer"
                className="group flex items-center justify-center space-x-3 bg-black text-white px-6 py-3 rounded-lg font-semibold hover:bg-gray-800 transition-colors duration-200"
              >
                <Download className="w-5 h-5" />
                <div className="text-left">
                  <div className="text-xs">Download on</div>
                  <div className="text-sm font-bold">Google Play</div>
                </div>
                <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform duration-200" />
              </a>
              
              <a
                href="#"
                className="group flex items-center justify-center space-x-3 bg-black text-white px-6 py-3 rounded-lg font-semibold hover:bg-gray-800 transition-colors duration-200"
              >
                <Download className="w-5 h-5" />
                <div className="text-left">
                  <div className="text-xs">Download on the</div>
                  <div className="text-sm font-bold">App Store</div>
                </div>
                <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform duration-200" />
              </a>
            </div>
          </div>

          {/* QR Code Side */}
          <div className="flex justify-center lg:justify-end">
            <div className="bg-white rounded-2xl p-8 shadow-xl border border-gray-100 text-center max-w-sm">
              <div className="mb-6">
                <h3 className="text-xl font-semibold text-gray-900 mb-2">
                  Scan to Download
                </h3>
                <p className="text-gray-600 text-sm">
                  Use your phone camera to scan the QR code
                </p>
              </div>
              
              <div className="flex justify-center mb-6">
                <div className="p-4 bg-gray-50 rounded-xl">
                  <canvas 
                    ref={canvasRef}
                    className="max-w-full h-auto"
                  />
                </div>
              </div>
              
              <div className="text-xs text-gray-500">
                <p>Currently redirects to ICPS app</p>
                <p className="mt-1">GPL mobile app coming soon!</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default QRCodeSection;
