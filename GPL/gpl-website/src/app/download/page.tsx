'use client';

import { useEffect, useRef } from 'react';
import { Smartphone, Download, Star, ArrowRight, CheckCircle, Apple, Play } from 'lucide-react';
import QRCode from 'qrcode';

export default function DownloadPage() {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    const generateQR = async () => {
      if (canvasRef.current) {
        try {
          // Using ICPS Google Play Store as placeholder
          const playStoreUrl = 'https://play.google.com/store/apps/details?id=com.icpc.tools';
          
          await QRCode.toCanvas(canvasRef.current, playStoreUrl, {
            width: 250,
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

  const features = [
    'Offline problem solving capability',
    'Real-time contest notifications',
    'Synchronized progress across devices',
    'Dark mode for comfortable coding',
    'Multiple programming language support',
    'Detailed performance analytics',
    'Community forums and discussions',
    'Push notifications for tournaments'
  ];

  return (
    <div className="pt-16">
      {/* Hero Section */}
      <section className="py-20 bg-gradient-to-br from-blue-50 to-purple-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-4xl mx-auto">
            <div className="inline-flex items-center space-x-2 bg-blue-100 text-blue-800 px-4 py-2 rounded-full text-sm font-medium mb-6">
              <Smartphone className="w-4 h-4" />
              <span>Mobile App Available</span>
            </div>
            
            <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
              Download <span className="gradient-text">GPL Mobile</span>
            </h1>
            <p className="text-xl text-gray-600 leading-relaxed">
              Take your competitive programming journey anywhere with our powerful mobile application. 
              Practice, compete, and connect with the global programming community on the go.
            </p>
          </div>
        </div>
      </section>

      {/* Download Section */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            {/* Content Side */}
            <div>
              <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-6">
                Code Anywhere, <span className="gradient-text">Anytime</span>
              </h2>
              
              <p className="text-lg text-gray-600 mb-8 leading-relaxed">
                Our mobile app brings the full GPL experience to your smartphone and tablet. 
                Whether you're commuting, traveling, or just prefer mobile coding, 
                you'll have access to all the features you love.
              </p>

              {/* Download Buttons */}
              <div className="flex flex-col sm:flex-row gap-4 mb-8">
                <a
                  href="https://play.google.com/store/apps/details?id=com.icpc.tools"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="group flex items-center justify-center space-x-3 bg-black text-white px-6 py-4 rounded-lg font-semibold hover:bg-gray-800 transition-colors duration-200"
                >
                  <Play className="w-6 h-6" />
                  <div className="text-left">
                    <div className="text-xs">Get it on</div>
                    <div className="text-lg font-bold">Google Play</div>
                  </div>
                  <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform duration-200" />
                </a>
                
                <a
                  href="#"
                  className="group flex items-center justify-center space-x-3 bg-black text-white px-6 py-4 rounded-lg font-semibold hover:bg-gray-800 transition-colors duration-200"
                >
                  <Apple className="w-6 h-6" />
                  <div className="text-left">
                    <div className="text-xs">Download on the</div>
                    <div className="text-lg font-bold">App Store</div>
                  </div>
                  <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform duration-200" />
                </a>
              </div>

              <div className="text-sm text-gray-500">
                <p>* Currently redirects to ICPS app as placeholder</p>
                <p>GPL mobile app coming soon!</p>
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
                    Use your phone camera to scan the QR code and download instantly
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
                  <p>Scan with your camera app</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Mobile App <span className="gradient-text">Features</span>
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Everything you need for competitive programming, optimized for mobile devices.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-4xl mx-auto">
            {features.map((feature, index) => (
              <div
                key={index}
                className="flex items-center space-x-3 bg-white p-4 rounded-lg shadow-sm border border-gray-100"
              >
                <CheckCircle className="w-5 h-5 text-green-500 flex-shrink-0" />
                <span className="text-gray-700">{feature}</span>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Screenshots Section */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              App <span className="gradient-text">Preview</span>
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Get a glimpse of the beautiful and intuitive mobile interface.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-4xl mx-auto">
            {[1, 2, 3].map((index) => (
              <div
                key={index}
                className="bg-gradient-to-br from-blue-500 to-purple-600 rounded-2xl p-8 text-white text-center"
              >
                <Smartphone className="w-16 h-16 mx-auto mb-4" />
                <h3 className="text-lg font-semibold mb-2">
                  {index === 1 ? 'Problem Solving' : index === 2 ? 'Competitions' : 'Leaderboards'}
                </h3>
                <p className="text-blue-100 text-sm">
                  {index === 1 
                    ? 'Solve problems with our intuitive mobile code editor'
                    : index === 2 
                    ? 'Participate in live contests from anywhere'
                    : 'Track your progress and compare with others'
                  }
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* System Requirements */}
      <section className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              System <span className="gradient-text">Requirements</span>
            </h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl mx-auto">
            <div className="bg-white rounded-xl p-6 shadow-lg border border-gray-100">
              <div className="flex items-center space-x-3 mb-4">
                <Play className="w-8 h-8 text-green-500" />
                <h3 className="text-xl font-semibold text-gray-900">Android</h3>
              </div>
              <ul className="space-y-2 text-gray-600">
                <li>• Android 6.0 (API level 23) or higher</li>
                <li>• 2GB RAM minimum, 4GB recommended</li>
                <li>• 500MB free storage space</li>
                <li>• Internet connection required</li>
              </ul>
            </div>

            <div className="bg-white rounded-xl p-6 shadow-lg border border-gray-100">
              <div className="flex items-center space-x-3 mb-4">
                <Apple className="w-8 h-8 text-gray-800" />
                <h3 className="text-xl font-semibold text-gray-900">iOS</h3>
              </div>
              <ul className="space-y-2 text-gray-600">
                <li>• iOS 12.0 or later</li>
                <li>• iPhone 6s or newer</li>
                <li>• 500MB free storage space</li>
                <li>• Internet connection required</li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 hero-gradient">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="max-w-3xl mx-auto">
            <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
              Start Coding on Mobile Today
            </h2>
            <p className="text-xl text-blue-100 mb-8">
              Download the GPL mobile app and take your competitive programming skills to the next level.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <a
                href="https://play.google.com/store/apps/details?id=com.icpc.tools"
                target="_blank"
                rel="noopener noreferrer"
                className="px-8 py-3 bg-white text-blue-900 rounded-lg font-semibold hover:bg-blue-50 transition-colors duration-200"
              >
                Download Now
              </a>
              <a
                href="/"
                className="px-8 py-3 border-2 border-white text-white rounded-lg font-semibold hover:bg-white hover:text-blue-900 transition-colors duration-200"
              >
                Back to Home
              </a>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
