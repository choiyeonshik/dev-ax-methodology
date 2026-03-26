import { Card, CardContent } from "./ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "./ui/avatar";
import { Badge } from "./ui/badge";
import { Star, Quote, Users, Award, CheckCircle } from "lucide-react";

export function TestimonialsSection() {
  const testimonials = [
    {
      name: "김민수",
      location: "서울 강남구",
      rating: 5,
      comment: "실시간으로 정비 현황을 확인할 수 있어서 너무 편했어요. 투명한 가격과 친절한 서비스에 만족합니다!",
      service: "엔진오일 교체",
      avatar: "/api/placeholder/40/40"
    },
    {
      name: "박지영",
      location: "부산 해운대구",
      rating: 5,
      comment: "온라인 예약이 정말 간편하고, 정비사님이 중간중간 상황을 알려주셔서 안심이 됐어요.",
      service: "브레이크 점검",
      avatar: "/api/placeholder/40/40"
    },
    {
      name: "이상훈",
      location: "대구 수성구",
      rating: 5,
      comment: "다른 곳보다 가격도 합리적이고, 정비 후 상세한 리포트까지 받을 수 있어서 좋네요!",
      service: "종합점검",
      avatar: "/api/placeholder/40/40"
    },
    {
      name: "최수진",
      location: "인천 연수구",
      rating: 5,
      comment: "예약 시간을 정확히 지켜주시고, 불필요한 정비 권유 없이 필요한 것만 해주셔서 신뢰가 갑니다.",
      service: "타이어 교체",
      avatar: "/api/placeholder/40/40"
    }
  ];

  const trustMetrics = [
    {
      icon: Users,
      value: "2,500+",
      label: "누적 고객",
      description: "만족한 고객들"
    },
    {
      icon: Star,
      value: "4.9/5.0",
      label: "평균 평점",
      description: "고객 만족도"
    },
    {
      icon: Award,
      value: "98%",
      label: "재방문율",
      description: "신뢰도 지표"
    },
    {
      icon: CheckCircle,
      value: "100%",
      label: "정시 완료",
      description: "약속 준수율"
    }
  ];

  return (
    <section className="py-16 md:py-24 bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section Header */}
        <div className="text-center space-y-4 mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900">
            <span className="text-primary">2,500명</span>의 고객이 선택한
          </h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            실제 고객들의 솔직한 후기와 높은 만족도가 증명하는 신뢰할 수 있는 서비스입니다
          </p>
        </div>

        {/* Trust Metrics */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-16">
          {trustMetrics.map((metric, index) => {
            const IconComponent = metric.icon;
            return (
              <Card key={index} className="text-center p-6 card-shadow border-0 hover:scale-105 transition-transform duration-200">
                <CardContent className="space-y-3 p-0">
                  <div className="w-12 h-12 bg-primary/10 text-primary rounded-xl flex items-center justify-center mx-auto">
                    <IconComponent className="w-6 h-6" />
                  </div>
                  <div className="space-y-1">
                    <div className="text-2xl font-bold text-primary">{metric.value}</div>
                    <div className="font-semibold text-gray-900">{metric.label}</div>
                    <div className="text-sm text-gray-600">{metric.description}</div>
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </div>

        {/* Customer Testimonials */}
        <div className="space-y-8">
          <div className="text-center">
            <h3 className="text-2xl font-bold text-gray-900 mb-2">고객 후기</h3>
            <p className="text-gray-600">실제 이용 고객들의 생생한 경험담을 확인해보세요</p>
          </div>

          <div className="grid md:grid-cols-2 gap-6">
            {testimonials.map((testimonial, index) => (
              <Card key={index} className="card-shadow border-0 hover:shadow-lg transition-shadow duration-300">
                <CardContent className="p-6 space-y-4">
                  {/* Quote Icon */}
                  <div className="flex justify-between items-start">
                    <Quote className="w-8 h-8 text-primary/20" />
                    <Badge variant="outline" className="text-xs">
                      {testimonial.service}
                    </Badge>
                  </div>

                  {/* Rating */}
                  <div className="flex items-center space-x-1">
                    {[...Array(testimonial.rating)].map((_, starIndex) => (
                      <Star key={starIndex} className="w-4 h-4 fill-warning text-warning" />
                    ))}
                  </div>

                  {/* Comment */}
                  <p className="text-gray-700 leading-relaxed">
                    "{testimonial.comment}"
                  </p>

                  {/* Customer Info */}
                  <div className="flex items-center space-x-3 pt-4 border-t border-gray-100">
                    <Avatar className="w-10 h-10">
                      <AvatarImage src={testimonial.avatar} alt={testimonial.name} />
                      <AvatarFallback className="bg-primary/10 text-primary">
                        {testimonial.name.charAt(0)}
                      </AvatarFallback>
                    </Avatar>
                    <div>
                      <div className="font-semibold text-gray-900">{testimonial.name}</div>
                      <div className="text-sm text-gray-600">{testimonial.location}</div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>

        {/* CTA Section */}
        <div className="mt-16 bg-gradient-to-r from-primary to-primary/80 rounded-2xl p-8 md:p-12 text-center text-white">
          <div className="space-y-6">
            <h3 className="text-2xl md:text-3xl font-bold">
              지금 바로 신뢰할 수 있는 정비 서비스를 경험해보세요
            </h3>
            <p className="text-lg opacity-90 max-w-2xl mx-auto">
              투명한 가격, 실시간 현황 확인, 전문적인 서비스로 당신의 소중한 차량을 관리해드립니다
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <button className="bg-white text-primary hover:bg-gray-100 px-8 py-3 rounded-lg font-semibold transition-colors duration-200">
                무료 견적 받기
              </button>
              <button 
                className="bg-secondary hover:bg-secondary/90 px-8 py-3 rounded-lg font-semibold transition-colors duration-200"
                style={{ backgroundColor: 'var(--secondary)' }}
              >
                지금 예약하기
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}