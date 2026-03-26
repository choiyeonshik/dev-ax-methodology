import { Button } from "./ui/button";
import { Calendar, Clock, CheckCircle } from "lucide-react";
import carImage from "../assets/car.png";

interface HeroSectionProps {
  onStatusClick?: () => void;
  onBookingClick?: () => void;
}

export function HeroSection({
  onStatusClick,
  onBookingClick,
}: HeroSectionProps) {
  return (
    <section className="bg-gradient-to-br from-blue-50 to-white py-16 md:py-24">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid lg:grid-cols-2 gap-12 items-center">
          {/* Left Column - Content */}
          <div className="space-y-8">
            <div className="space-y-6">
              <div className="inline-flex items-center px-4 py-2 bg-primary/10 text-primary rounded-full">
                <CheckCircle className="w-4 h-4 mr-2" />
                <span className="text-sm font-medium">
                  신뢰할 수 있는 정비 서비스
                </span>
              </div>

              <h1 className="text-4xl md:text-5xl font-bold text-gray-900 leading-tight">
                신뢰할 수 있는
                <br />
                <span className="text-primary">차량 정비</span>,<br />
                실시간으로 확인하세요
              </h1>

              <p className="text-xl text-gray-600 leading-relaxed">
                투명한 가격, 실시간 정비 현황 확인, 전문 정비사의 꼼꼼한
                점검으로
                <br />
                안전하고 믿을 수 있는 차량 관리를 경험해보세요.
              </p>
            </div>

            {/* CTA Buttons */}
            <div className="flex flex-col sm:flex-row gap-4">
              <Button
                size="lg"
                className="btn-height bg-primary hover:bg-primary/90 text-white px-8"
                style={{ backgroundColor: "var(--primary)" }}
                onClick={onBookingClick}
              >
                <Calendar className="w-5 h-5 mr-2" />
                정비 예약하기
              </Button>
              <Button
                size="lg"
                variant="outline"
                className="btn-height border-primary text-primary hover:bg-primary/5 px-8"
                onClick={onStatusClick}
              >
                <Clock className="w-5 h-5 mr-2" />
                실시간 현황 확인
              </Button>
            </div>

            {/* Quick Stats */}
            <div className="grid grid-cols-3 gap-8 pt-8 border-t border-gray-200">
              <div className="text-center">
                <div className="text-2xl font-bold text-primary">2,500+</div>
                <div className="text-sm text-gray-600">완료된 정비</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-primary">98%</div>
                <div className="text-sm text-gray-600">고객 만족도</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-primary">24시간</div>
                <div className="text-sm text-gray-600">실시간 추적</div>
              </div>
            </div>
          </div>

          {/* Right Column - Car Image */}
          <div className="lg:pl-8">
            <img
              src={carImage}
              alt="현대적인 정비 서비스를 받는 자동차"
              className="w-full h-auto object-contain"
            />
          </div>
        </div>
      </div>
    </section>
  );
}
