import { 
  Trophy, 
  Code, 
  Users, 
  BookOpen, 
  Target, 
  Clock, 
  Award, 
  Zap, 
  Globe, 
  Brain,
  CheckCircle,
  ArrowRight
} from 'lucide-react';

export default function ServicesPage() {
  const services = [
    {
      icon: Trophy,
      title: 'Competitive Tournaments',
      description: 'Regular tournaments with varying difficulty levels and prize pools.',
      features: [
        'Weekly and monthly competitions',
        'Real-time leaderboards',
        'Cash prizes and recognition',
        'Team and individual contests'
      ],
      color: 'text-yellow-500',
      bgColor: 'bg-yellow-50',
      borderColor: 'border-yellow-200',
    },
    {
      icon: Code,
      title: 'Problem Library',
      description: 'Extensive collection of algorithmic problems across all difficulty levels.',
      features: [
        '10,000+ curated problems',
        'Multiple programming languages',
        'Detailed editorial solutions',
        'Progressive difficulty system'
      ],
      color: 'text-blue-500',
      bgColor: 'bg-blue-50',
      borderColor: 'border-blue-200',
    },
    {
      icon: BookOpen,
      title: 'Learning Resources',
      description: 'Comprehensive tutorials and guides for competitive programming.',
      features: [
        'Algorithm tutorials',
        'Data structure guides',
        'Video explanations',
        'Interactive examples'
      ],
      color: 'text-green-500',
      bgColor: 'bg-green-50',
      borderColor: 'border-green-200',
    },
    {
      icon: Users,
      title: 'Community Platform',
      description: 'Connect with programmers worldwide and share knowledge.',
      features: [
        'Discussion forums',
        'Solution sharing',
        'Mentorship programs',
        'Study groups'
      ],
      color: 'text-purple-500',
      bgColor: 'bg-purple-50',
      borderColor: 'border-purple-200',
    },
    {
      icon: Target,
      title: 'Skill Assessment',
      description: 'Track your progress and identify areas for improvement.',
      features: [
        'Performance analytics',
        'Skill rating system',
        'Progress tracking',
        'Personalized recommendations'
      ],
      color: 'text-red-500',
      bgColor: 'bg-red-50',
      borderColor: 'border-red-200',
    },
    {
      icon: Award,
      title: 'Certification Program',
      description: 'Earn recognized certificates for your programming achievements.',
      features: [
        'Industry-recognized certificates',
        'Skill verification',
        'Portfolio enhancement',
        'Career advancement'
      ],
      color: 'text-indigo-500',
      bgColor: 'bg-indigo-50',
      borderColor: 'border-indigo-200',
    },
  ];

  const plans = [
    {
      name: 'Free',
      price: '$0',
      period: 'forever',
      description: 'Perfect for getting started with competitive programming',
      features: [
        'Access to 1,000+ problems',
        'Participate in public contests',
        'Basic performance analytics',
        'Community forum access',
        'Mobile app access'
      ],
      cta: 'Get Started',
      popular: false,
    },
    {
      name: 'Pro',
      price: '$19',
      period: 'per month',
      description: 'For serious competitive programmers',
      features: [
        'Access to all 10,000+ problems',
        'Priority contest registration',
        'Advanced analytics & insights',
        'Video tutorials & editorials',
        'Direct mentor support',
        'Custom practice sessions'
      ],
      cta: 'Start Pro Trial',
      popular: true,
    },
    {
      name: 'Team',
      price: '$99',
      period: 'per month',
      description: 'For organizations and educational institutions',
      features: [
        'Everything in Pro',
        'Team management dashboard',
        'Custom contests & problems',
        'Bulk user management',
        'Advanced reporting',
        'Dedicated support'
      ],
      cta: 'Contact Sales',
      popular: false,
    },
  ];

  return (
    <div className="pt-16">
      {/* Hero Section */}
      <section className="py-20 bg-gradient-to-br from-blue-50 to-purple-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-4xl mx-auto">
            <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
              Our <span className="gradient-text">Services</span>
            </h1>
            <p className="text-xl text-gray-600 leading-relaxed">
              Comprehensive competitive programming solutions designed to help you excel 
              in coding challenges and advance your programming career.
            </p>
          </div>
        </div>
      </section>

      {/* Services Grid */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              What We <span className="gradient-text">Offer</span>
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Everything you need to master competitive programming and excel in your coding journey.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {services.map((service, index) => (
              <div
                key={index}
                className={`card-hover bg-white rounded-xl p-6 shadow-lg border-2 ${service.borderColor}`}
              >
                <div className={`w-12 h-12 ${service.bgColor} rounded-lg flex items-center justify-center mb-4`}>
                  <service.icon className={`w-6 h-6 ${service.color}`} />
                </div>
                <h3 className="text-xl font-semibold text-gray-900 mb-3">
                  {service.title}
                </h3>
                <p className="text-gray-600 mb-4">
                  {service.description}
                </p>
                <ul className="space-y-2">
                  {service.features.map((feature, featureIndex) => (
                    <li key={featureIndex} className="flex items-center space-x-2">
                      <CheckCircle className="w-4 h-4 text-green-500 flex-shrink-0" />
                      <span className="text-sm text-gray-600">{feature}</span>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Pricing Section */}
      <section className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Choose Your <span className="gradient-text">Plan</span>
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Select the perfect plan for your competitive programming journey.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto">
            {plans.map((plan, index) => (
              <div
                key={index}
                className={`relative bg-white rounded-2xl p-8 shadow-lg border-2 ${
                  plan.popular ? 'border-blue-500 transform scale-105' : 'border-gray-200'
                }`}
              >
                {plan.popular && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                      Most Popular
                    </span>
                  </div>
                )}
                
                <div className="text-center mb-6">
                  <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.name}</h3>
                  <div className="mb-2">
                    <span className="text-4xl font-bold text-gray-900">{plan.price}</span>
                    <span className="text-gray-600">/{plan.period}</span>
                  </div>
                  <p className="text-gray-600">{plan.description}</p>
                </div>

                <ul className="space-y-3 mb-8">
                  {plan.features.map((feature, featureIndex) => (
                    <li key={featureIndex} className="flex items-center space-x-3">
                      <CheckCircle className="w-5 h-5 text-green-500 flex-shrink-0" />
                      <span className="text-gray-700">{feature}</span>
                    </li>
                  ))}
                </ul>

                <button
                  className={`w-full py-3 px-6 rounded-lg font-semibold transition-colors duration-200 ${
                    plan.popular
                      ? 'bg-blue-500 text-white hover:bg-blue-600'
                      : 'bg-gray-100 text-gray-900 hover:bg-gray-200'
                  }`}
                >
                  {plan.cta}
                </button>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 hero-gradient">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="max-w-3xl mx-auto">
            <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
              Ready to Elevate Your Programming Skills?
            </h2>
            <p className="text-xl text-blue-100 mb-8">
              Join thousands of developers who are already improving their competitive programming skills with GPL.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <a
                href="http://localhost:3000"
                target="_blank"
                rel="noopener noreferrer"
                className="group px-8 py-3 bg-white text-blue-900 rounded-lg font-semibold hover:bg-blue-50 transition-colors duration-200 flex items-center justify-center space-x-2"
              >
                <span>Start Your Journey</span>
                <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform duration-200" />
              </a>
              <a
                href="/about"
                className="px-8 py-3 border-2 border-white text-white rounded-lg font-semibold hover:bg-white hover:text-blue-900 transition-colors duration-200"
              >
                Learn More About Us
              </a>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
