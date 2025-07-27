import { Trophy, Users, Code, Target, Clock, Award, Zap, Globe } from 'lucide-react';

const FeaturesSection = () => {
  const features = [
    {
      icon: Trophy,
      title: 'Competitive Tournaments',
      description: 'Participate in regular coding tournaments with programmers from around the world. Test your skills and climb the global leaderboards.',
      color: 'text-yellow-500',
      bgColor: 'bg-yellow-50',
    },
    {
      icon: Code,
      title: 'Diverse Problem Sets',
      description: 'Access thousands of carefully curated programming problems across multiple difficulty levels and algorithmic concepts.',
      color: 'text-blue-500',
      bgColor: 'bg-blue-50',
    },
    {
      icon: Users,
      title: 'Global Community',
      description: 'Connect with like-minded developers, share solutions, and learn from the best programmers worldwide.',
      color: 'text-green-500',
      bgColor: 'bg-green-50',
    },
    {
      icon: Target,
      title: 'Skill Assessment',
      description: 'Track your progress with detailed analytics and personalized recommendations to improve your coding abilities.',
      color: 'text-purple-500',
      bgColor: 'bg-purple-50',
    },
    {
      icon: Clock,
      title: 'Real-time Contests',
      description: 'Experience the thrill of live coding competitions with real-time leaderboards and instant feedback.',
      color: 'text-red-500',
      bgColor: 'bg-red-50',
    },
    {
      icon: Award,
      title: 'Recognition System',
      description: 'Earn badges, certificates, and recognition for your achievements. Build your programming portfolio.',
      color: 'text-indigo-500',
      bgColor: 'bg-indigo-50',
    },
    {
      icon: Zap,
      title: 'Fast Execution',
      description: 'Lightning-fast code execution with support for multiple programming languages and instant results.',
      color: 'text-orange-500',
      bgColor: 'bg-orange-50',
    },
    {
      icon: Globe,
      title: 'Multi-Platform',
      description: 'Access GPL from anywhere - web, mobile, or desktop. Your progress syncs across all devices.',
      color: 'text-teal-500',
      bgColor: 'bg-teal-50',
    },
  ];

  return (
    <section className="py-20 bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section Header */}
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
            Why Choose <span className="gradient-text">Global Programming League</span>?
          </h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            Discover the features that make GPL the premier destination for competitive programming enthusiasts worldwide.
          </p>
        </div>

        {/* Features Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {features.map((feature, index) => (
            <div
              key={index}
              className="card-hover bg-white rounded-xl p-6 shadow-lg border border-gray-100"
            >
              <div className={`w-12 h-12 ${feature.bgColor} rounded-lg flex items-center justify-center mb-4`}>
                <feature.icon className={`w-6 h-6 ${feature.color}`} />
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">
                {feature.title}
              </h3>
              <p className="text-gray-600 leading-relaxed">
                {feature.description}
              </p>
            </div>
          ))}
        </div>

        {/* CTA Section */}
        <div className="text-center mt-16">
          <div className="bg-white rounded-2xl p-8 shadow-lg border border-gray-100 max-w-4xl mx-auto">
            <h3 className="text-2xl md:text-3xl font-bold text-gray-900 mb-4">
              Ready to Start Your Programming Journey?
            </h3>
            <p className="text-lg text-gray-600 mb-6">
              Join thousands of developers who are already improving their skills with GPL.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <a
                href="/tournaments"
                className="px-8 py-3 hero-gradient text-white rounded-lg font-semibold hover:opacity-90 transition-opacity duration-200"
              >
                Get Started Now
              </a>
              <a
                href="/contact"
                className="px-8 py-3 border-2 border-gray-300 text-gray-700 rounded-lg font-semibold hover:border-blue-500 hover:text-blue-600 transition-colors duration-200"
              >
                Learn More
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default FeaturesSection;
