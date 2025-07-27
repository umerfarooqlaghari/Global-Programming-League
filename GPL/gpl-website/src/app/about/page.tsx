import { Target, Users, Globe, Award, Code, Heart, Lightbulb, Rocket } from 'lucide-react';

export default function AboutPage() {
  const values = [
    {
      icon: Target,
      title: 'Excellence',
      description: 'We strive for the highest standards in competitive programming education and platform development.',
      color: 'text-blue-500',
      bgColor: 'bg-blue-50',
    },
    {
      icon: Users,
      title: 'Community',
      description: 'Building a supportive global community where programmers can learn, grow, and succeed together.',
      color: 'text-green-500',
      bgColor: 'bg-green-50',
    },
    {
      icon: Globe,
      title: 'Accessibility',
      description: 'Making competitive programming accessible to everyone, regardless of background or location.',
      color: 'text-purple-500',
      bgColor: 'bg-purple-50',
    },
    {
      icon: Lightbulb,
      title: 'Innovation',
      description: 'Continuously innovating to provide the best learning and competitive programming experience.',
      color: 'text-yellow-500',
      bgColor: 'bg-yellow-50',
    },
  ];

  const team = [
    {
      name: 'Dr. Sarah Chen',
      role: 'Founder & CEO',
      description: 'Former ICPC World Champion with 15+ years in competitive programming.',
      image: '/team/placeholder.jpg',
    },
    {
      name: 'Alex Rodriguez',
      role: 'CTO',
      description: 'Expert in scalable systems and algorithmic problem design.',
      image: '/team/placeholder.jpg',
    },
    {
      name: 'Maria Kowalski',
      role: 'Head of Community',
      description: 'Building bridges between programmers worldwide.',
      image: '/team/placeholder.jpg',
    },
    {
      name: 'David Kim',
      role: 'Lead Developer',
      description: 'Creating seamless user experiences for competitive programming.',
      image: '/team/placeholder.jpg',
    },
  ];

  return (
    <div className="pt-16">
      {/* Hero Section */}
      <section className="py-20 bg-gradient-to-br from-blue-50 to-purple-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-4xl mx-auto">
            <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
              About <span className="gradient-text">Global Programming League</span>
            </h1>
            <p className="text-xl text-gray-600 leading-relaxed">
              We're on a mission to democratize competitive programming and create the world's 
              largest community of skilled developers through engaging challenges and tournaments.
            </p>
          </div>
        </div>
      </section>

      {/* Mission & Vision */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div>
              <div className="flex items-center space-x-2 mb-4">
                <Rocket className="w-6 h-6 text-blue-500" />
                <span className="text-blue-500 font-semibold">Our Mission</span>
              </div>
              <h2 className="text-3xl font-bold text-gray-900 mb-6">
                Empowering Programmers Worldwide
              </h2>
              <p className="text-lg text-gray-600 mb-6 leading-relaxed">
                Our mission is to provide a comprehensive platform where programmers of all skill levels 
                can enhance their abilities through competitive programming. We believe that coding is not 
                just about solving problems—it's about building a community, fostering innovation, and 
                creating opportunities for growth.
              </p>
              <p className="text-lg text-gray-600 leading-relaxed">
                Through carefully designed challenges, real-time competitions, and a supportive community, 
                we're helping developers around the world reach their full potential.
              </p>
            </div>
            <div className="bg-gradient-to-br from-blue-500 to-purple-600 rounded-2xl p-8 text-white">
              <Heart className="w-12 h-12 mb-4" />
              <h3 className="text-2xl font-bold mb-4">Our Vision</h3>
              <p className="text-lg leading-relaxed">
                To become the global standard for competitive programming education and competition, 
                where every developer can find their path to excellence and contribute to a thriving 
                community of innovators.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Values */}
      <section className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Our Core <span className="gradient-text">Values</span>
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              These principles guide everything we do and shape the experience we create for our community.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {values.map((value, index) => (
              <div
                key={index}
                className="card-hover bg-white rounded-xl p-6 shadow-lg border border-gray-100 text-center"
              >
                <div className={`w-16 h-16 ${value.bgColor} rounded-full flex items-center justify-center mx-auto mb-4`}>
                  <value.icon className={`w-8 h-8 ${value.color}`} />
                </div>
                <h3 className="text-xl font-semibold text-gray-900 mb-3">
                  {value.title}
                </h3>
                <p className="text-gray-600 leading-relaxed">
                  {value.description}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Story */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="max-w-4xl mx-auto">
            <div className="text-center mb-12">
              <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
                Our <span className="gradient-text">Story</span>
              </h2>
            </div>
            
            <div className="prose prose-lg max-w-none">
              <p className="text-lg text-gray-600 mb-6 leading-relaxed">
                Global Programming League was born from a simple observation: while competitive programming 
                was transforming careers and building incredible problem-solving skills, it remained 
                inaccessible to many talented developers around the world.
              </p>
              
              <p className="text-lg text-gray-600 mb-6 leading-relaxed">
                Founded in 2020 by a team of former ICPC champions and industry veterans, GPL started as 
                a small platform with big dreams. We wanted to create a space where anyone, regardless 
                of their background or location, could access high-quality competitive programming resources 
                and compete with the best minds globally.
              </p>
              
              <p className="text-lg text-gray-600 mb-6 leading-relaxed">
                Today, GPL has grown into a thriving community of over 50,000 programmers from 150+ countries. 
                We've hosted more than 1,200 tournaments, facilitated millions of problem solutions, and 
                helped countless developers land their dream jobs at top tech companies.
              </p>
              
              <p className="text-lg text-gray-600 leading-relaxed">
                But we're just getting started. Our vision extends beyond just competitions—we're building 
                the future of programming education, one challenge at a time.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 hero-gradient">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="max-w-3xl mx-auto">
            <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
              Ready to Join Our Community?
            </h2>
            <p className="text-xl text-blue-100 mb-8">
              Become part of the global programming revolution and start your journey to coding excellence.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <a
                href="http://localhost:3000"
                target="_blank"
                rel="noopener noreferrer"
                className="px-8 py-3 bg-white text-blue-900 rounded-lg font-semibold hover:bg-blue-50 transition-colors duration-200"
              >
                Start Competing
              </a>
              <a
                href="/services"
                className="px-8 py-3 border-2 border-white text-white rounded-lg font-semibold hover:bg-white hover:text-blue-900 transition-colors duration-200"
              >
                Explore Services
              </a>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
