'use client';

import { useEffect, useState } from 'react';
import { Trophy, Users, Code, Globe, TrendingUp, Award } from 'lucide-react';

const StatsSection = () => {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true);
        }
      },
      { threshold: 0.1 }
    );

    const element = document.getElementById('stats-section');
    if (element) {
      observer.observe(element);
    }

    return () => {
      if (element) {
        observer.unobserve(element);
      }
    };
  }, []);

  const stats = [
    {
      icon: Users,
      value: '50,000+',
      label: 'Active Programmers',
      description: 'Developers from 150+ countries',
      color: 'text-blue-500',
      bgColor: 'bg-blue-50',
    },
    {
      icon: Trophy,
      value: '1,200+',
      label: 'Tournaments Hosted',
      description: 'Monthly competitive events',
      color: 'text-yellow-500',
      bgColor: 'bg-yellow-50',
    },
    {
      icon: Code,
      value: '10M+',
      label: 'Problems Solved',
      description: 'Across all difficulty levels',
      color: 'text-green-500',
      bgColor: 'bg-green-50',
    },
    {
      icon: Globe,
      value: '150+',
      label: 'Countries',
      description: 'Global programming community',
      color: 'text-purple-500',
      bgColor: 'bg-purple-50',
    },
    {
      icon: TrendingUp,
      value: '95%',
      label: 'Skill Improvement',
      description: 'Users report better coding skills',
      color: 'text-red-500',
      bgColor: 'bg-red-50',
    },
    {
      icon: Award,
      value: '25,000+',
      label: 'Certificates Earned',
      description: 'Professional recognition',
      color: 'text-indigo-500',
      bgColor: 'bg-indigo-50',
    },
  ];

  return (
    <section id="stats-section" className="py-20 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section Header */}
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
            GPL by the <span className="gradient-text">Numbers</span>
          </h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            See how our global community of programmers is growing and achieving excellence together.
          </p>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {stats.map((stat, index) => (
            <div
              key={index}
              className={`card-hover bg-white rounded-xl p-8 shadow-lg border border-gray-100 text-center transform transition-all duration-700 ${
                isVisible 
                  ? 'translate-y-0 opacity-100' 
                  : 'translate-y-8 opacity-0'
              }`}
              style={{ transitionDelay: `${index * 100}ms` }}
            >
              <div className={`w-16 h-16 ${stat.bgColor} rounded-full flex items-center justify-center mx-auto mb-4`}>
                <stat.icon className={`w-8 h-8 ${stat.color}`} />
              </div>
              
              <div className="mb-2">
                <span className="text-4xl md:text-5xl font-bold text-gray-900">
                  {stat.value}
                </span>
              </div>
              
              <h3 className="text-xl font-semibold text-gray-900 mb-2">
                {stat.label}
              </h3>
              
              <p className="text-gray-600">
                {stat.description}
              </p>
            </div>
          ))}
        </div>

        {/* Achievement Highlights */}
        <div className="mt-20">
          <div className="bg-gradient-to-r from-blue-50 to-purple-50 rounded-2xl p-8 md:p-12">
            <div className="text-center mb-8">
              <h3 className="text-2xl md:text-3xl font-bold text-gray-900 mb-4">
                Recent Achievements
              </h3>
              <p className="text-lg text-gray-600">
                Celebrating milestones in our programming community
              </p>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              <div className="text-center">
                <div className="w-12 h-12 bg-yellow-100 rounded-lg flex items-center justify-center mx-auto mb-3">
                  <Trophy className="w-6 h-6 text-yellow-600" />
                </div>
                <h4 className="font-semibold text-gray-900 mb-1">World Championship 2024</h4>
                <p className="text-gray-600 text-sm">Successfully hosted our largest tournament with 10,000+ participants</p>
              </div>
              
              <div className="text-center">
                <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mx-auto mb-3">
                  <Users className="w-6 h-6 text-green-600" />
                </div>
                <h4 className="font-semibold text-gray-900 mb-1">50K Members Milestone</h4>
                <p className="text-gray-600 text-sm">Reached 50,000 active programmers from around the globe</p>
              </div>
              
              <div className="text-center">
                <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mx-auto mb-3">
                  <Code className="w-6 h-6 text-blue-600" />
                </div>
                <h4 className="font-semibold text-gray-900 mb-1">New Problem Sets</h4>
                <p className="text-gray-600 text-sm">Added 500+ new algorithmic challenges this quarter</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default StatsSection;
