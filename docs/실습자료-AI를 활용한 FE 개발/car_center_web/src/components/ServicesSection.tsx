import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { 
  Calendar, 
  Search, 
  Calculator, 
  History, 
  ArrowRight,
  Star,
  Clock,
  Shield
} from "lucide-react";

interface ServicesSectionProps {
  onStatusClick?: () => void;
  onBookingClick?: () => void;
  onServiceHistoryClick?: () => void;
}

export function ServicesSection({ onStatusClick, onBookingClick, onServiceHistoryClick }: ServicesSectionProps) {
  const services = [
    {
      icon: Calendar,
      title: "정비 예약",
      description: "간편한 온라인 예약으로 원하는 시간에 정비 서비스를 받으세요",
      features: ["원하는 날짜/시간 선택", "정비 항목 사전 선택", "예약 확인 알림"],
      buttonText: "예약하기",
      buttonVariant: "default" as const,
      popular: false
    },
    {
      icon: Search,
      title: "실시간 현황 확인",
      description: "정비 진행상황을 실시간으로 확인하고 완료 예정시간을 알 수 있어요",
      features: ["실시간 진행상황", "완료 예정시간 안내", "정비사 직접 소통"],
      buttonText: "현황 확인",
      buttonVariant: "secondary" as const,
      popular: true
    },
    {
      icon: Calculator,
      title: "견적 조회",
      description: "정비 전 투명한 견적을 미리 확인하고 합리적인 가격으로 정비하세요",
      features: ["투명한 가격 공개", "부품 가격 상세 안내", "할인 혜택 적용"],
      buttonText: "견적 받기",
      buttonVariant: "outline" as const,
      popular: false
    },
    {
      icon: History,
      title: "정비 이력",
      description: "과거 정비 내역을 한눈에 보고 차량 관리 계획을 세워보세요",
      features: ["전체 정비 이력", "정비 주기 알림", "차량 상태 리포트"],
      buttonText: "이력 보기",
      buttonVariant: "outline" as const,
      popular: false
    }
  ];

  return (
    <section className="py-16 md:py-24 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section Header */}
        <div className="text-center space-y-4 mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900">
            편리한 <span className="text-primary">디지털 정비</span> 서비스
          </h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            예약부터 완료까지, 모든 과정을 투명하게 확인할 수 있는 스마트한 정비 경험을 제공합니다
          </p>
        </div>

        {/* Services Grid */}
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
          {services.map((service, index) => {
            const IconComponent = service.icon;
            return (
              <Card key={index} className={`relative card-shadow border-0 hover:shadow-lg transition-all duration-300 group ${service.popular ? 'ring-2 ring-secondary ring-opacity-50' : ''}`}>
                {service.popular && (
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <Badge 
                      className="bg-secondary text-white px-3 py-1"
                      style={{ backgroundColor: 'var(--secondary)' }}
                    >
                      <Star className="w-3 h-3 mr-1" />
                      인기
                    </Badge>
                  </div>
                )}
                
                <CardHeader className="text-center space-y-4 pb-4">
                  <div className={`w-16 h-16 mx-auto rounded-xl flex items-center justify-center ${service.popular ? 'bg-secondary text-white' : 'bg-primary/10 text-primary'} group-hover:scale-110 transition-transform duration-300`}>
                    <IconComponent className="w-8 h-8" />
                  </div>
                  <div className="space-y-2">
                    <CardTitle className="text-xl">{service.title}</CardTitle>
                    <CardDescription className="text-gray-600 leading-relaxed">
                      {service.description}
                    </CardDescription>
                  </div>
                </CardHeader>

                <CardContent className="space-y-6">
                  {/* Features List */}
                  <ul className="space-y-2">
                    {service.features.map((feature, featureIndex) => (
                      <li key={featureIndex} className="flex items-center text-sm text-gray-600">
                        <div className="w-1.5 h-1.5 bg-primary rounded-full mr-3 flex-shrink-0"></div>
                        {feature}
                      </li>
                    ))}
                  </ul>

                  {/* CTA Button */}
                  <Button 
                    variant={service.buttonVariant}
                    className={`w-full btn-height group-hover:scale-105 transition-transform duration-200 ${
                      service.buttonVariant === 'secondary' 
                        ? 'bg-secondary hover:bg-secondary/90 text-white' 
                        : service.buttonVariant === 'default'
                        ? 'bg-primary hover:bg-primary/90 text-white'
                        : 'border-primary text-primary hover:bg-primary/5'
                    }`}
                    style={service.buttonVariant === 'secondary' ? { backgroundColor: 'var(--secondary)' } : 
                           service.buttonVariant === 'default' ? { backgroundColor: 'var(--primary)' } : {}}
                    onClick={service.title === '실시간 현황 확인' ? onStatusClick : 
                           service.title === '정비 예약' ? onBookingClick :
                           service.title === '정비 이력' ? onServiceHistoryClick : undefined}
                  >
                    {service.buttonText}
                    <ArrowRight className="w-4 h-4 ml-2" />
                  </Button>
                </CardContent>
              </Card>
            );
          })}
        </div>

        {/* Additional Trust Indicators */}
        <div className="mt-16 bg-gray-50 rounded-2xl p-8">
          <div className="grid md:grid-cols-3 gap-8 text-center">
            <div className="space-y-3">
              <div className="w-12 h-12 bg-success/10 text-success rounded-xl flex items-center justify-center mx-auto">
                <Shield className="w-6 h-6" />
              </div>
              <h4 className="font-semibold text-gray-900">품질 보장</h4>
              <p className="text-sm text-gray-600">모든 정비는 자격을 갖춘 전문 정비사가 담당합니다</p>
            </div>
            
            <div className="space-y-3">
              <div className="w-12 h-12 bg-warning/10 text-warning rounded-xl flex items-center justify-center mx-auto">
                <Clock className="w-6 h-6" />
              </div>
              <h4 className="font-semibold text-gray-900">신속한 서비스</h4>
              <p className="text-sm text-gray-600">평균 2시간 내 완료되는 빠른 정비 서비스</p>
            </div>
            
            <div className="space-y-3">
              <div className="w-12 h-12 bg-primary/10 text-primary rounded-xl flex items-center justify-center mx-auto">
                <Star className="w-6 h-6" />
              </div>
              <h4 className="font-semibold text-gray-900">고객 만족</h4>
              <p className="text-sm text-gray-600">98% 고객 만족도를 유지하는 신뢰할 수 있는 서비스</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}