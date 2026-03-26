import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { Checkbox } from "./ui/checkbox";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "./ui/tooltip";
import { 
  ArrowRight,
  Wrench,
  Gauge,
  Search,
  Zap,
  Wind,
  Cog,
  Shield,
  Thermometer,
  Battery,
  CheckCircle2,
  Info,
  Star,
  Clock
} from "lucide-react";

interface Service {
  id: string;
  name: string;
  category: string;
  price: number;
  duration: string;
  description: string;
  icon: React.ElementType;
  popular?: boolean;
}

interface ServiceBookingProps {
  onNext: (selectedServices: any[]) => void;
}

export function ServiceBooking({ onNext }: ServiceBookingProps) {
  const [selectedServices, setSelectedServices] = useState<string[]>([]);

  const services: Service[] = [
    {
      id: "engine-oil",
      name: "엔진오일 교체",
      category: "인기 서비스",
      price: 80000,
      duration: "30분",
      description: "고품질 엔진오일로 교체하여 엔진 성능을 최적화합니다",
      icon: Wrench,
      popular: true
    },
    {
      id: "brake-pad",
      name: "브레이크 패드 교체",
      category: "인기 서비스", 
      price: 120000,
      duration: "1시간",
      description: "안전한 제동력 확보를 위한 브레이크 패드 교체",
      icon: Shield,
      popular: true
    },
    {
      id: "inspection",
      name: "정기점검",
      category: "인기 서비스",
      price: 50000,
      duration: "45분", 
      description: "차량 전반적인 상태를 점검하여 문제를 사전에 발견합니다",
      icon: Search,
      popular: true
    },
    {
      id: "battery",
      name: "배터리 점검",
      category: "전기계통",
      price: 30000,
      duration: "20분",
      description: "배터리 성능 점검 및 충전 상태 확인",
      icon: Battery
    },
    {
      id: "air-filter",
      name: "에어필터 교체",
      category: "필터류",
      price: 25000,
      duration: "15분", 
      description: "깨끗한 공기 공급을 위한 에어필터 교체",
      icon: Wind
    },
    {
      id: "coolant",
      name: "냉각수 보충",
      category: "냉각계통",
      price: 40000,
      duration: "25분",
      description: "엔진 과열 방지를 위한 냉각수 점검 및 보충",
      icon: Thermometer
    },
    {
      id: "spark-plug",
      name: "점화플러그 교체",
      category: "엔진",
      price: 60000,
      duration: "40분",
      description: "연비 향상과 엔진 성능 개선을 위한 점화플러그 교체",
      icon: Zap
    },
    {
      id: "tire-rotation",
      name: "타이어 로테이션",
      category: "타이어",
      price: 35000,
      duration: "30분",
      description: "타이어 수명 연장을 위한 위치 교환",
      icon: Cog
    },
    {
      id: "transmission",
      name: "변속기 오일 교체",
      category: "변속기",
      price: 150000,
      duration: "1시간 30분",
      description: "부드러운 변속을 위한 변속기 오일 교체",
      icon: Gauge
    }
  ];

  const popularServices = services.filter(service => service.popular);
  const otherServices = services.filter(service => !service.popular);
  
  const categories = Array.from(new Set(otherServices.map(service => service.category)));

  const toggleService = (serviceId: string) => {
    setSelectedServices(prev => 
      prev.includes(serviceId)
        ? prev.filter(id => id !== serviceId)
        : [...prev, serviceId]
    );
  };

  const getTotalPrice = () => {
    return selectedServices.reduce((total, serviceId) => {
      const service = services.find(s => s.id === serviceId);
      return total + (service?.price || 0);
    }, 0);
  };

  const getTotalDuration = () => {
    const totalMinutes = selectedServices.reduce((total, serviceId) => {
      const service = services.find(s => s.id === serviceId);
      const duration = service?.duration || "0분";
      const minutes = duration.includes("시간") 
        ? parseInt(duration) * 60 + (parseInt(duration.split("시간")[1]) || 0)
        : parseInt(duration);
      return total + minutes;
    }, 0);

    if (totalMinutes >= 60) {
      const hours = Math.floor(totalMinutes / 60);
      const minutes = totalMinutes % 60;
      return minutes > 0 ? `${hours}시간 ${minutes}분` : `${hours}시간`;
    }
    return `${totalMinutes}분`;
  };

  const ServiceCard = ({ service, isSelected, onToggle }: { 
    service: Service; 
    isSelected: boolean; 
    onToggle: () => void;
  }) => {
    const IconComponent = service.icon;
    
    return (
      <Card 
        className={`relative cursor-pointer transition-all duration-200 hover:shadow-lg ${
          isSelected 
            ? 'ring-2 ring-primary bg-primary/5 border-primary' 
            : 'border-gray-200 hover:border-primary/50'
        } ${service.popular ? 'border-secondary/30' : ''}`}
        onClick={onToggle}
      >
        {service.popular && (
          <div className="absolute -top-2 -right-2 z-10">
            <Badge className="bg-secondary text-white text-xs px-2 py-1">
              <Star className="w-3 h-3 mr-1" />
              인기
            </Badge>
          </div>
        )}
        
        <CardHeader className="pb-3">
          <div className="flex items-start justify-between">
            <div className="flex items-center gap-3">
              <div className={`p-2 rounded-lg ${
                isSelected ? 'bg-primary text-white' : 'bg-primary/10 text-primary'
              }`}>
                <IconComponent className="w-5 h-5" />
              </div>
              <div>
                <CardTitle className="text-base">{service.name}</CardTitle>
                <p className="text-sm text-gray-500 mt-1">{service.category}</p>
              </div>
            </div>
            <Checkbox 
              checked={isSelected}
              onChange={onToggle}
              className="data-[state=checked]:bg-primary data-[state=checked]:border-primary"
            />
          </div>
        </CardHeader>
        
        <CardContent className="pt-0">
          <div className="flex justify-between items-center mb-3">
            <div className="text-lg font-bold text-primary">
              {service.price.toLocaleString()}원
            </div>
            <div className="flex items-center gap-1 text-sm text-gray-600">
              <Clock className="w-4 h-4" />
              {service.duration}
            </div>
          </div>
          
          <div className="flex items-start gap-2">
            <p className="text-sm text-gray-600 flex-1">{service.description}</p>
            <TooltipProvider>
              <Tooltip>
                <TooltipTrigger>
                  <Info className="w-4 h-4 text-gray-400 hover:text-gray-600 transition-colors" />
                </TooltipTrigger>
                <TooltipContent>
                  <p className="max-w-xs">{service.description}</p>
                </TooltipContent>
              </Tooltip>
            </TooltipProvider>
          </div>
        </CardContent>
      </Card>
    );
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="mb-6">
            <h1 className="text-2xl font-bold text-gray-900">서비스 예약</h1>
            <p className="text-gray-600 mt-1">필요한 서비스를 선택해주세요</p>
          </div>

          {/* Progress Steps */}
          <div className="bg-gradient-to-r from-blue-50 to-orange-50 rounded-xl p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="text-sm font-medium text-gray-600">예약 진행 단계</div>
              <div className="text-sm text-primary font-medium">1/4 단계</div>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center text-white font-medium text-sm">
                1
              </div>
              <div className="flex-1 h-1 bg-gray-200 rounded-full">
                <div className="w-1/4 h-1 bg-gradient-to-r from-primary to-secondary rounded-full"></div>
              </div>
              <div className="text-sm font-medium text-primary">서비스 선택</div>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Popular Services */}
        <div className="mb-12">
          <div className="flex items-center gap-2 mb-6">
            <Star className="w-5 h-5 text-secondary" />
            <h2 className="text-xl font-bold text-gray-900">인기 서비스</h2>
            <Badge variant="secondary" className="bg-secondary/10 text-secondary">
              추천
            </Badge>
          </div>
          <div className="grid md:grid-cols-3 gap-6">
            {popularServices.map(service => (
              <ServiceCard
                key={service.id}
                service={service}
                isSelected={selectedServices.includes(service.id)}
                onToggle={() => toggleService(service.id)}
              />
            ))}
          </div>
        </div>

        {/* All Services by Category */}
        <div className="mb-20">
          <h2 className="text-xl font-bold text-gray-900 mb-6">전체 서비스</h2>
          {categories.map(category => {
            const categoryServices = otherServices.filter(service => service.category === category);
            return (
              <div key={category} className="mb-8">
                <h3 className="font-semibold text-gray-900 mb-4 flex items-center gap-2">
                  <div className="w-2 h-2 bg-primary rounded-full"></div>
                  {category}
                  <span className="text-sm text-gray-500">({categoryServices.length}개)</span>
                </h3>
                <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {categoryServices.map(service => (
                    <ServiceCard
                      key={service.id}
                      service={service}
                      isSelected={selectedServices.includes(service.id)}
                      onToggle={() => toggleService(service.id)}
                    />
                  ))}
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Fixed Bottom Summary */}
      {selectedServices.length > 0 && (
        <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 shadow-lg z-50">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-6">
                <div className="flex items-center gap-2">
                  <CheckCircle2 className="w-5 h-5 text-success" />
                  <span className="font-medium text-gray-900">
                    {selectedServices.length}개 서비스 선택됨
                  </span>
                </div>
                <div className="flex items-center gap-4 text-sm text-gray-600">
                  <div>예상 소요시간: <span className="font-medium">{getTotalDuration()}</span></div>
                  <div className="w-1 h-1 bg-gray-300 rounded-full"></div>
                  <div>총 금액: <span className="font-bold text-primary text-lg">{getTotalPrice().toLocaleString()}원</span></div>
                </div>
              </div>
              <Button 
                size="lg" 
                className="bg-primary hover:bg-primary/90 btn-height px-8"
                onClick={() => {
                  const selectedServiceData = selectedServices.map(serviceId => {
                    const service = services.find(s => s.id === serviceId);
                    return service ? {
                      id: service.id,
                      name: service.name,
                      price: service.price,
                      duration: service.duration
                    } : null;
                  }).filter(Boolean);
                  onNext(selectedServiceData);
                }}
              >
                다음 단계
                <ArrowRight className="w-4 h-4 ml-2" />
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}