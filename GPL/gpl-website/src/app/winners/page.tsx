'use client';

import { useEffect, useState } from 'react';
import { Trophy, Crown, Medal, Star, Users, Award, TrendingUp } from 'lucide-react';

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

interface TopPerformer {
  username: string;
  totalWins: number;
  totalScore: number;
  competitions: string[];
  averageRank: number;
}

export default function WinnersPage() {
  const [rankings, setRankings] = useState<Ranking[]>([]);
  const [topPerformers, setTopPerformers] = useState<TopPerformer[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch('http://localhost:5500/api/all-rankings');
        if (response.ok) {
          const data = await response.json();
          setRankings(data);
          
          // Process data to find top performers
          const performerStats: { [key: string]: TopPerformer } = {};
          
          data.forEach((ranking: Ranking) => {
            ranking.rankings.forEach((participant) => {
              if (!performerStats[participant.username]) {
                performerStats[participant.username] = {
                  username: participant.username,
                  totalWins: 0,
                  totalScore: 0,
                  competitions: [],
                  averageRank: 0,
                };
              }
              
              const performer = performerStats[participant.username];
              performer.totalScore += participant.score;
              performer.competitions.push(ranking.competitionName);
              
              if (participant.rank === 1) {
                performer.totalWins++;
              }
            });
          });
          
          // Calculate average rank and sort by performance
          const performers = Object.values(performerStats).map(performer => {
            const totalRanks = data.reduce((sum: number, ranking: Ranking) => {
              const participant = ranking.rankings.find(p => p.username === performer.username);
              return participant ? sum + participant.rank : sum;
            }, 0);
            
            performer.averageRank = totalRanks / performer.competitions.length;
            return performer;
          });
          
          // Sort by wins first, then by total score
          performers.sort((a, b) => {
            if (b.totalWins !== a.totalWins) return b.totalWins - a.totalWins;
            return b.totalScore - a.totalScore;
          });
          
          setTopPerformers(performers.slice(0, 10));
        }
      } catch (err) {
        setError('Failed to fetch winners data. Please ensure the Node.js server is running on port 5500.');
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
        month: 'short',
        day: 'numeric'
      });
    } catch {
      return dateString;
    }
  };

  const getRankIcon = (rank: number) => {
    switch (rank) {
      case 1:
        return <Crown className="w-6 h-6 text-yellow-500" />;
      case 2:
        return <Medal className="w-6 h-6 text-gray-500" />;
      case 3:
        return <Medal className="w-6 h-6 text-orange-500" />;
      default:
        return <Trophy className="w-6 h-6 text-blue-500" />;
    }
  };

  if (loading) {
    return (
      <div className="pt-16 min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto mb-4"></div>
          <p className="text-gray-600">Loading winners data...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="pt-16">
      {/* Hero Section */}
      <section className="py-20 bg-gradient-to-br from-yellow-50 to-orange-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-4xl mx-auto">
            <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
              <span className="gradient-text">Champions</span> & Winners
            </h1>
            <p className="text-xl text-gray-600 leading-relaxed">
              Celebrating the exceptional programmers who have demonstrated outstanding skills 
              and achieved victory in our competitive programming tournaments.
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

      {/* Top Performers */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Top <span className="gradient-text">Performers</span>
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Our most successful competitive programmers who have consistently excelled across multiple tournaments.
            </p>
          </div>

          {topPerformers.length > 0 ? (
            <>
              {/* Podium - Top 3 */}
              <div className="flex justify-center items-end space-x-4 mb-16">
                {topPerformers.slice(0, 3).map((performer, index) => {
                  const positions = [1, 0, 2]; // Second, First, Third
                  const actualIndex = positions[index];
                  const heights = ['h-32', 'h-40', 'h-28'];
                  const colors = ['bg-gray-100', 'bg-yellow-100', 'bg-orange-100'];
                  
                  return (
                    <div key={performer.username} className="text-center">
                      <div className={`${heights[index]} ${colors[index]} rounded-t-lg p-4 flex flex-col justify-end items-center border-2 ${
                        actualIndex === 0 ? 'border-yellow-300' : 
                        actualIndex === 1 ? 'border-gray-300' : 'border-orange-300'
                      }`}>
                        <div className="mb-2">
                          {getRankIcon(actualIndex + 1)}
                        </div>
                        <div className="font-bold text-gray-900">{performer.username}</div>
                        <div className="text-sm text-gray-600">{performer.totalWins} wins</div>
                        <div className="text-xs text-gray-500">{performer.totalScore} pts</div>
                      </div>
                      <div className={`w-full h-8 ${
                        actualIndex === 0 ? 'bg-yellow-200' : 
                        actualIndex === 1 ? 'bg-gray-200' : 'bg-orange-200'
                      } flex items-center justify-center font-bold text-lg`}>
                        {actualIndex + 1}
                      </div>
                    </div>
                  );
                })}
              </div>

              {/* Leaderboard */}
              <div className="bg-white rounded-xl shadow-lg border border-gray-100 overflow-hidden">
                <div className="bg-gradient-to-r from-blue-500 to-purple-600 text-white p-6">
                  <h3 className="text-2xl font-bold flex items-center space-x-2">
                    <TrendingUp className="w-6 h-6" />
                    <span>Global Leaderboard</span>
                  </h3>
                </div>
                
                <div className="divide-y divide-gray-200">
                  {topPerformers.map((performer, index) => (
                    <div
                      key={performer.username}
                      className={`p-6 flex items-center justify-between hover:bg-gray-50 transition-colors duration-200 ${
                        index < 3 ? 'bg-gradient-to-r from-yellow-50 to-orange-50' : ''
                      }`}
                    >
                      <div className="flex items-center space-x-4">
                        <div className={`w-10 h-10 rounded-full flex items-center justify-center font-bold ${
                          index === 0 ? 'bg-yellow-500 text-white' :
                          index === 1 ? 'bg-gray-500 text-white' :
                          index === 2 ? 'bg-orange-500 text-white' :
                          'bg-blue-100 text-blue-600'
                        }`}>
                          {index + 1}
                        </div>
                        <div>
                          <div className="font-semibold text-gray-900 text-lg">
                            {performer.username}
                          </div>
                          <div className="text-sm text-gray-600">
                            Participated in {performer.competitions.length} competitions
                          </div>
                        </div>
                      </div>
                      
                      <div className="text-right">
                        <div className="flex items-center space-x-4">
                          <div className="text-center">
                            <div className="font-bold text-yellow-600">{performer.totalWins}</div>
                            <div className="text-xs text-gray-600">Wins</div>
                          </div>
                          <div className="text-center">
                            <div className="font-bold text-blue-600">{performer.totalScore}</div>
                            <div className="text-xs text-gray-600">Total Score</div>
                          </div>
                          <div className="text-center">
                            <div className="font-bold text-green-600">{performer.averageRank.toFixed(1)}</div>
                            <div className="text-xs text-gray-600">Avg Rank</div>
                          </div>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </>
          ) : (
            <div className="text-center py-12">
              <Trophy className="w-16 h-16 text-gray-300 mx-auto mb-4" />
              <h3 className="text-xl font-semibold text-gray-900 mb-2">No Winners Data</h3>
              <p className="text-gray-600">Winners will appear here after competitions are completed.</p>
            </div>
          )}
        </div>
      </section>

      {/* Recent Competition Winners */}
      <section className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Recent <span className="gradient-text">Competition Winners</span>
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Latest champions from our most recent programming competitions.
            </p>
          </div>

          {rankings.length > 0 ? (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {rankings.slice(0, 6).map((ranking) => {
                const winner = ranking.rankings.find(p => p.rank === 1);
                if (!winner) return null;
                
                return (
                  <div
                    key={ranking._id}
                    className="bg-white rounded-xl p-6 shadow-lg border border-gray-100 card-hover"
                  >
                    <div className="text-center mb-4">
                      <Crown className="w-12 h-12 text-yellow-500 mx-auto mb-2" />
                      <h3 className="text-lg font-semibold text-gray-900">
                        {ranking.competitionName}
                      </h3>
                      <p className="text-sm text-gray-600">
                        {formatDate(ranking.createdAt)}
                      </p>
                    </div>
                    
                    <div className="bg-gradient-to-r from-yellow-50 to-orange-50 rounded-lg p-4 border border-yellow-200">
                      <div className="text-center">
                        <div className="font-bold text-xl text-gray-900 mb-1">
                          {winner.username}
                        </div>
                        <div className="text-yellow-600 font-semibold mb-2">
                          🏆 Champion
                        </div>
                        <div className="flex justify-center space-x-4 text-sm">
                          <div>
                            <span className="font-semibold">{winner.score}</span>
                            <span className="text-gray-600"> points</span>
                          </div>
                          <div>
                            <span className="font-semibold">{winner.timeTaken}</span>
                            <span className="text-gray-600"> time</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          ) : (
            <div className="text-center py-12">
              <Award className="w-16 h-16 text-gray-300 mx-auto mb-4" />
              <h3 className="text-xl font-semibold text-gray-900 mb-2">No Recent Winners</h3>
              <p className="text-gray-600">Recent winners will appear here after competitions.</p>
            </div>
          )}
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 hero-gradient">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="max-w-3xl mx-auto">
            <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
              Become the Next Champion
            </h2>
            <p className="text-xl text-blue-100 mb-8">
              Join our competitive programming community and compete for the top spot on our leaderboards.
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
                href="/tournaments"
                className="px-8 py-3 border-2 border-white text-white rounded-lg font-semibold hover:bg-white hover:text-blue-900 transition-colors duration-200"
              >
                View Tournaments
              </a>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
