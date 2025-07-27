import HeroSection from '@/components/HeroSection';
import FeaturesSection from '@/components/FeaturesSection';
import StatsSection from '@/components/StatsSection';
import QRCodeSection from '@/components/QRCodeSection';

export default function Home() {
  return (
    <div className="pt-16">
      <HeroSection />
      <FeaturesSection />
      <StatsSection />
      <QRCodeSection />
    </div>
  );
}

