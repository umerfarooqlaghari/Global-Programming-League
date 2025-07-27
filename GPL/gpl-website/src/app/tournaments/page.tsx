'use client';

import { useEffect, useState } from 'react';
import { Trophy, Calendar, Users, Clock, Award, MapPin, ExternalLink } from 'lucide-react';

interface Competition {
  _id: string;
  title: string;
  description: string;
  date: string;
  time: string;
  duration: string;
  registrationLink: string;
  createdAt: string;
}

interface Ranking {
  _id: string;
  competitionName: string;
  rankings: Array<{
    rank: number;
    username: string;
    score: number;
    timeTaken: string;
  }>;
  createdAt: string;
}

export default function TournamentsPage() {
  const [competitions, setCompetitions] = useState<Competition[]>([]);
  const [rankings, setRankings] = useState<Ranking[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        // Fetch competitions
        const competitionsResponse = await fetch('http://localhost:5500/api/competitions');
        if (competitionsResponse.ok) {
          const competitionsData = await competitionsResponse.json();
          setCompetitions(competitionsData);
        }

        // Fetch all rankings
        const rankingsResponse = await fetch('http://localhost:5500/api/all-rankings');
        if (rankingsResponse.ok) {
          const rankingsData = await rankingsResponse.json();
          setRankings(rankingsData);
        }
      } catch (err) {
        setError('Failed to fetch tournament data. Please ensure the Node.js server is running on port 5500.');
        console.error('Error fetching data:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const formatDate = (dateString: string) => {
    try {
      return new Date(dateString).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    } catch {
      return dateString;
    }
  };

  if (loading) {
    return (
      <div className="pt-16 min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto mb-4"></div>
          <p className="text-gray-600">Loading tournament data...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="pt-16">
      {/* Hero Section */}
      <section className="py-20 bg-gradient-to-br from-blue-50 to-purple-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-4xl mx-auto">
            <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
              <span className="gradient-text">Tournaments</span> & Competitions
            </h1>
            <p className="text-xl text-gray-600 leading-relaxed">
              Explore our exciting competitive programming tournaments and see how the best programmers 
              from around the world compete for glory and prizes.
            </p>
          </div>
        </div>
      </section>

      {error && (
        <section className="py-8 bg-red-50">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
              <p>{error}</p>
            </div>
          </div>
        </section>
      )}

      {/* Upcoming Competitions */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Upcoming <span className="gradient-text">Competitions</span>
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Don't miss out on these exciting upcoming tournaments. Register now to secure your spot!
            </p>
          </div>

          {competitions.length > 0 ? (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {competitions.map((competition) => (
                <div
                  key={competition._id}
                  className="card-hover bg-white rounded-xl p-6 shadow-lg border border-gray-100"
                >
                  <div className="flex items-center space-x-2 mb-4">
                    <Trophy className="w-6 h-6 text-yellow-500" />
                    <span className="text-sm font-medium text-yellow-600 bg-yellow-50 px-2 py-1 rounded">
                      Upcoming
                    </span>
                  </div>
                  
                  <h3 className="text-xl font-semibold text-gray-900 mb-3">
                    {competition.title}
                  </h3>
                  
                  <p className="text-gray-600 mb-4 line-clamp-3">
                    {competition.description}
                  </p>
                  
                  <div className="space-y-2 mb-6">
                    <div className="flex items-center space-x-2 text-sm text-gray-600">
                      <Calendar className="w-4 h-4" />
                      <span>{formatDate(competition.date)}</span>
                    </div>
                    <div className="flex items-center space-x-2 text-sm text-gray-600">
                      <Clock className="w-4 h-4" />
                      <span>{competition.time} ({competition.duration})</span>
                    </div>
                  </div>
                  
                  {competition.registrationLink && (
                    <a
                      href={competition.registrationLink}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="inline-flex items-center space-x-2 bg-blue-500 text-white px-4 py-2 rounded-lg font-medium hover:bg-blue-600 transition-colors duration-200"
                    >
                      <span>Register Now</span>
                      <ExternalLink className="w-4 h-4" />
                    </a>
                  )}
                </div>
              ))}
            </div>
          ) : (
            <div className="text-center py-12">
              <Trophy className="w-16 h-16 text-gray-300 mx-auto mb-4" />
              <h3 className="text-xl font-semibold text-gray-900 mb-2">No Upcoming Competitions</h3>
              <p className="text-gray-600">Check back soon for new tournament announcements!</p>
            </div>
          )}
        </div>
      </section>

      {/* Past Tournament Results */}
      <section className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Tournament <span className="gradient-text">Results</span>
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Celebrate the achievements of our top performers in past competitions.
            </p>
          </div>

          {rankings.length > 0 ? (
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
              {rankings.slice(0, 6).map((ranking) => (
                <div
                  key={ranking._id}
                  className="bg-white rounded-xl p-6 shadow-lg border border-gray-100"
                >
                  <div className="flex items-center space-x-2 mb-4">
                    <Award className="w-6 h-6 text-purple-500" />
                    <h3 className="text-xl font-semibold text-gray-900">
                      {ranking.competitionName}
                    </h3>
                  </div>
                  
                  <div className="space-y-3">
                    {ranking.rankings.slice(0, 3).map((participant, index) => (
                      <div
                        key={index}
                        className={`flex items-center justify-between p-3 rounded-lg ${
                          index === 0 ? 'bg-yellow-50 border border-yellow-200' :
                          index === 1 ? 'bg-gray-50 border border-gray-200' :
                          'bg-orange-50 border border-orange-200'
                        }`}
                      >
                        <div className="flex items-center space-x-3">
                          <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-sm ${
                            index === 0 ? 'bg-yellow-500 text-white' :
                            index === 1 ? 'bg-gray-500 text-white' :
                            'bg-orange-500 text-white'
                          }`}>
                            {participant.rank}
                          </div>
                          <span className="font-medium text-gray-900">
                            {participant.username}
                          </span>
                        </div>
                        <div className="text-right">
                          <div className="font-semibold text-gray-900">
                            {participant.score} pts
                          </div>
                          <div className="text-sm text-gray-600">
                            {participant.timeTaken}
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                  
                  {ranking.rankings.length > 3 && (
                    <div className="mt-4 text-center">
                      <span className="text-sm text-gray-600">
                        +{ranking.rankings.length - 3} more participants
                      </span>
                    </div>
                  )}
                </div>
              ))}
            </div>
          ) : (
            <div className="text-center py-12">
              <Award className="w-16 h-16 text-gray-300 mx-auto mb-4" />
              <h3 className="text-xl font-semibold text-gray-900 mb-2">No Tournament Results</h3>
              <p className="text-gray-600">Results will appear here after competitions are completed.</p>
            </div>
          )}
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 hero-gradient">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="max-w-3xl mx-auto">
            <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
              Ready to Compete?
            </h2>
            <p className="text-xl text-blue-100 mb-8">
              Join our next tournament and test your programming skills against the best developers worldwide.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <a
                href="http://localhost:3000"
                target="_blank"
                rel="noopener noreferrer"
                className="px-8 py-3 bg-white text-blue-900 rounded-lg font-semibold hover:bg-blue-50 transition-colors duration-200"
              >
                Join Tournament
              </a>
              <a
                href="/services"
                className="px-8 py-3 border-2 border-white text-white rounded-lg font-semibold hover:bg-white hover:text-blue-900 transition-colors duration-200"
              >
                View All Services
              </a>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
