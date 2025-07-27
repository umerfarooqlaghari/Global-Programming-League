'use client';

import { useState } from 'react';
import Link from 'next/link';
import { Menu, X, Code, Trophy, Users, Info, Settings, ExternalLink, Mail } from 'lucide-react';

const Header = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const navigation = [
    { name: 'Home', href: '/', icon: Code },
    { name: 'About Us', href: '/about', icon: Info },
    { name: 'Our Services', href: '/services', icon: Settings },
    { name: 'Tournaments', href: '/tournaments', icon: Trophy },
    { name: 'Winners', href: '/winners', icon: Users },
    { name: 'Contact', href: '/contact', icon: Mail },
  ];

  return (
    <header className="fixed top-0 left-0 right-0 z-50 bg-white/90 backdrop-blur-md border-b border-gray-200">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <Link href="/" className="flex items-center space-x-2 flex-shrink-0">
            <div className="w-10 h-10 hero-gradient rounded-lg flex items-center justify-center">
              <Code className="w-6 h-6 text-white" />
            </div>
            <span className="text-xl pr-8 font-bold gradient-text whitespace-nowrap">
              Global Programming League
            </span>
          </Link>

          {/* Desktop Navigation */}
          <nav className="hidden lg:flex items-center pr-4 space-x-6 flex-1 justify-center">
            {navigation.map((item) => (
              <Link
                key={item.name}
                href={item.href}
                className="flex items-center space-x-1 pr-4 text-gray-700 hover:text-blue-600 transition-colors duration-200 font-medium whitespace-nowrap"
              >
                <item.icon className="w-4 h-4" />
                <span>{item.name}</span>
              </Link>
            ))}
          </nav>

          {/* CTA Buttons */}
          <div className="hidden lg:flex items-center space-x-4 flex-shrink-0">
            <Link
              href="/download"
              className="px-4 py-2 text-sm font-medium text-gray-700 hover:text-blue-600 transition-colors duration-200"
            >
              Download App
            </Link>
            <Link
              href="http://localhost:3000" // This will be updated to point to Flutter app
              target="_blank"
              rel="noopener noreferrer"
              className="px-6 py-2 hero-gradient text-white rounded-lg font-medium hover:opacity-90 transition-opacity duration-200 flex items-center space-x-2"
            >
              <span>Access Portal</span>
              <ExternalLink className="w-4 h-4" />
            </Link>
          </div>

          {/* Mobile menu button */}
          <button
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            className="lg:hidden p-2 rounded-lg text-gray-700 hover:bg-gray-100 transition-colors duration-200"
          >
            {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>
      </div>

      {/* Mobile Navigation */}
      {isMenuOpen && (
        <div className="lg:hidden bg-white border-t border-gray-200">
          <div className="px-4 py-2 space-y-1">
            {navigation.map((item) => (
              <Link
                key={item.name}
                href={item.href}
                className="flex items-center space-x-2 px-3 py-2 rounded-lg text-gray-700 hover:bg-gray-100 transition-colors duration-200"
                onClick={() => setIsMenuOpen(false)}
              >
                <item.icon className="w-4 h-4" />
                <span>{item.name}</span>
              </Link>
            ))}
            <div className="pt-2 border-t border-gray-200 space-y-2">
              <Link
                href="/download"
                className="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-lg transition-colors duration-200"
                onClick={() => setIsMenuOpen(false)}
              >
                Download App
              </Link>
              <Link
                href="http://localhost:3000"
                target="_blank"
                rel="noopener noreferrer"
                className="block px-3 py-2 hero-gradient text-white rounded-lg font-medium text-center"
                onClick={() => setIsMenuOpen(false)}
              >
                Access Portal
              </Link>
            </div>
          </div>
        </div>
      )}
    </header>
  );
};

export default Header;
