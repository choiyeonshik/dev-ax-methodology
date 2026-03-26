import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "./ui/select";
import { Input } from "./ui/input";
import { Progress } from "./ui/progress";
import { 
  Calendar,
  Car,
  Search,
  Download,
  TrendingUp,
  Wrench,
  DollarSign,
  Clock,
  AlertTriangle,
  CheckCircle2,
  FileText,
  BarChart3,
  Gauge
} from "lucide-react";

interface ServiceRecord {
  id: string;
  date: string;
  services: string[];
  cost: number;
  mileage: number;
  vehicle: {
    licensePlate: string;
    model: string;
  };
  location: string;
  technician: string;
  notes?: string;
  nextRecommended?: {
    service: string;
    mileage: number;
  };
}

interface ServiceHistoryProps {}

export function ServiceHistory({}: ServiceHistoryProps) {
  const [vehicleFilter, setVehicleFilter] = useState<string>('all');
  const [searchQuery, setSearchQuery] = useState('');

  // Mock service history data
  const vehicles = [
    { licensePlate: '12가3456', model: '현대 아반떼' },
    { licensePlate: '78나9012', model: '기아 K5' },
    { licensePlate: '34다5678', model: '현대 소나타' }
  ];

  const serviceRecords: ServiceRecord[] = [
    {
      id: '1',
      date: '2024.12.08',
      services: ['엔진오일 교체', '에어필터 교체'],
      cost: 85000,
      mileage: 35500,
      vehicle: { licensePlate: '12가3456', model: '현대 아반떼' },
      location: '강남점',
      technician: '김정비',
      notes: '엔진 상태 양호, 다음 교체까지 5,000km',
      nextRecommended: { service: '정기점검', mileage: 40000 }
    },
    {
      id: '2',
      date: '2024.11.15',
      services: ['브레이크 패드 교체', '브레이크 오일 교체'],
      cost: 180000,
      mileage: 48200,
      vehicle: { licensePlate: '78나9012', model: '기아 K5' },
      location: '서초점',
      technician: '박정비',
      notes: '브레이크 시스템 전체 점검 완료'
    },
    {
      id: '3',
      date: '2024.10.22',
      services: ['타이어 4개 교체'],
      cost: 320000,
      mileage: 45000,
      vehicle: { licensePlate: '34다5678', model: '현대 소나타' },
      location: '강남점',
      technician: '이정비',
      notes: '겨울용 타이어로 교체',
      nextRecommended: { service: '타이어 점검', mileage: 55000 }
    },
    {
      id: '4',
      date: '2024.09.10',
      services: ['에어컨 점검', '냉매 보충'],
      cost: 65000,
      mileage: 34800,
      vehicle: { licensePlate: '12가3456', model: '현대 아반떼' },
      location: '강남점',
      technician: '김정비'
    },
    {
      id: '5',
      date: '2024.08.05',
      services: ['정기점검', '오일 교체'],
      cost: 120000,
      mileage: 47500,
      vehicle: { licensePlate: '78나9012', model: '기아 K5' },
      location: '서초점',
      technician: '박정비'
    }
  ];

  const filteredRecords = serviceRecords.filter(record => {
    const matchesVehicle = vehicleFilter === 'all' || record.vehicle.licensePlate === vehicleFilter;
    const matchesSearch = searchQuery === '' ||
      record.services.some(service => service.toLowerCase().includes(searchQuery.toLowerCase())) ||
      record.vehicle.licensePlate.includes(searchQuery) ||
      record.technician.includes(searchQuery);
    
    return matchesVehicle && matchesSearch;
  });

  // Statistics
  const totalRecords = filteredRecords.length;
  const totalCost = filteredRecords.reduce((sum, record) => sum + record.cost, 0);
  const averageCost = totalRecords > 0 ? Math.round(totalCost / totalRecords) : 0;
  
  const upcomingRecommendations = filteredRecords
    .filter(record => record.nextRecommended)
    .map(record => ({
      vehicle: record.vehicle,
      recommendation: record.nextRecommended!,
      currentMileage: record.mileage
    }));

  const ServiceRecordCard = ({ record }: { record: ServiceRecord }) => {
    return (
      <Card className="hover:shadow-lg transition-shadow duration-200 border-0 card-shadow">
        <CardContent className="p-6">
          <div className="flex items-start justify-between mb-4">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-primary/10 rounded-lg">
                <Wrench className="w-5 h-5 text-primary" />
              </div>
              <div>
                <div className="font-medium text-gray-900">{record.date}</div>
                <div className="text-sm text-gray-500">{record.location} · {record.technician}</div>
              </div>
            </div>
            <div className="text-right">
              <div className="font-bold text-primary">{record.cost.toLocaleString()}원</div>
              <div className="text-sm text-gray-500 flex items-center gap-1">
                <Gauge className="w-3 h-3" />
                {record.mileage.toLocaleString()}km
              </div>
            </div>
          </div>

          <div className="grid md:grid-cols-2 gap-4 mb-4">
            <div>
              <div className="flex items-center gap-2 mb-2">
                <Car className="w-4 h-4 text-gray-500" />
                <span className="text-sm text-gray-600">차량 정보</span>
              </div>
              <div className="ml-6">
                <div className="font-medium">{record.vehicle.licensePlate}</div>
                <div className="text-sm text-gray-500">{record.vehicle.model}</div>
              </div>
            </div>
            
            <div>
              <div className="flex items-center gap-2 mb-2">
                <CheckCircle2 className="w-4 h-4 text-gray-500" />
                <span className="text-sm text-gray-600">실시된 서비스</span>
              </div>
              <div className="ml-6 flex flex-wrap gap-1">
                {record.services.map((service, index) => (
                  <Badge key={index} variant="secondary" className="bg-success/10 text-success text-xs">
                    {service}
                  </Badge>
                ))}
              </div>
            </div>
          </div>

          {record.notes && (
            <div className="mb-4 p-3 bg-blue-50 rounded-lg">
              <div className="flex items-center gap-2 mb-1">
                <FileText className="w-4 h-4 text-blue-600" />
                <span className="text-sm font-medium text-blue-800">정비 메모</span>
              </div>
              <p className="text-sm text-blue-700 ml-6">{record.notes}</p>
            </div>
          )}

          {record.nextRecommended && (
            <div className="pt-4 border-t border-gray-200">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <AlertTriangle className="w-4 h-4 text-warning" />
                  <span className="text-sm font-medium text-warning">다음 권장 정비</span>
                </div>
                <div className="text-right">
                  <div className="text-sm font-medium text-gray-900">{record.nextRecommended.service}</div>
                  <div className="text-xs text-gray-500">{record.nextRecommended.mileage.toLocaleString()}km 예상</div>
                </div>
              </div>
            </div>
          )}
        </CardContent>
      </Card>
    );
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">정비 이력</h1>
            <p className="text-gray-600 mt-1">나의 차량 정비 기록을 확인하세요</p>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid lg:grid-cols-4 gap-8">
          {/* Statistics Cards */}
          <div className="lg:col-span-4 grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
            <Card className="card-shadow border-0 bg-gradient-to-br from-primary/5 to-primary/10">
              <CardContent className="p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-600">총 정비 횟수</p>
                    <p className="text-2xl font-bold text-primary">{totalRecords}회</p>
                  </div>
                  <div className="p-3 bg-primary/10 rounded-lg">
                    <BarChart3 className="w-6 h-6 text-primary" />
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="card-shadow border-0 bg-gradient-to-br from-secondary/5 to-secondary/10">
              <CardContent className="p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-600">총 정비 비용</p>
                    <p className="text-2xl font-bold text-secondary">{totalCost.toLocaleString()}원</p>
                  </div>
                  <div className="p-3 bg-secondary/10 rounded-lg">
                    <DollarSign className="w-6 h-6 text-secondary" />
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="card-shadow border-0 bg-gradient-to-br from-success/5 to-success/10">
              <CardContent className="p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-600">평균 정비 비용</p>
                    <p className="text-2xl font-bold text-success">{averageCost.toLocaleString()}원</p>
                  </div>
                  <div className="p-3 bg-success/10 rounded-lg">
                    <TrendingUp className="w-6 h-6 text-success" />
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="card-shadow border-0 bg-gradient-to-br from-warning/5 to-warning/10">
              <CardContent className="p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-600">권장 정비</p>
                    <p className="text-2xl font-bold text-warning">{upcomingRecommendations.length}건</p>
                  </div>
                  <div className="p-3 bg-warning/10 rounded-lg">
                    <Clock className="w-6 h-6 text-warning" />
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Filters and Content */}
          <div className="lg:col-span-3 space-y-6">
            {/* Filters */}
            <Card className="card-shadow border-0">
              <CardContent className="p-6">
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <div>
                    <label className="block text-sm text-gray-600 mb-2">차량 선택</label>
                    <Select value={vehicleFilter} onValueChange={setVehicleFilter}>
                      <SelectTrigger>
                        <SelectValue placeholder="차량 선택" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="all">전체 차량</SelectItem>
                        {vehicles.map(vehicle => (
                          <SelectItem key={vehicle.licensePlate} value={vehicle.licensePlate}>
                            {vehicle.licensePlate} ({vehicle.model})
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                  
                  <div className="md:col-span-2">
                    <label className="block text-sm text-gray-600 mb-2">검색</label>
                    <div className="relative">
                      <Search className="w-4 h-4 text-gray-500 absolute left-3 top-1/2 transform -translate-y-1/2" />
                      <Input
                        placeholder="서비스명, 차량번호, 정비사명으로 검색"
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        className="pl-10"
                      />
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Service History */}
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-bold text-gray-900">정비 기록 ({filteredRecords.length}건)</h2>
              <Button variant="outline" size="sm">
                <Download className="w-4 h-4 mr-2" />
                PDF 다운로드
              </Button>
            </div>

            <div className="space-y-4">
              {filteredRecords.length === 0 ? (
                <Card className="card-shadow border-0">
                  <CardContent className="p-12 text-center">
                    <Wrench className="w-12 h-12 text-gray-400 mx-auto mb-4" />
                    <h3 className="text-lg font-medium text-gray-900 mb-2">정비 이력이 없습니다</h3>
                    <p className="text-gray-600">아직 등록된 정비 기록��� 없습니다.</p>
                  </CardContent>
                </Card>
              ) : (
                filteredRecords.map(record => (
                  <ServiceRecordCard key={record.id} record={record} />
                ))
              )}
            </div>
          </div>

          {/* Recommendations Sidebar */}
          <div className="space-y-6">
            {/* Next Recommended Services */}
            <Card className="card-shadow border-0">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <AlertTriangle className="w-5 h-5 text-warning" />
                  다음 권장 정비
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                {upcomingRecommendations.length === 0 ? (
                  <div className="text-center py-4">
                    <CheckCircle2 className="w-8 h-8 text-success mx-auto mb-2" />
                    <p className="text-sm text-gray-600">현재 권장되는 정비가 없습니다.</p>
                  </div>
                ) : (
                  upcomingRecommendations.map((item, index) => {
                    const progress = Math.min(100, (item.currentMileage / item.recommendation.mileage) * 100);
                    const remainingKm = item.recommendation.mileage - item.currentMileage;
                    
                    return (
                      <div key={index} className="p-4 border border-warning/20 bg-warning/5 rounded-lg">
                        <div className="flex items-start justify-between mb-3">
                          <div>
                            <div className="font-medium text-gray-900">{item.vehicle.licensePlate}</div>
                            <div className="text-sm text-gray-600">{item.vehicle.model}</div>
                          </div>
                          <Badge variant="outline" className="bg-warning/10 text-warning border-warning/20">
                            {remainingKm > 0 ? `${remainingKm.toLocaleString()}km 후` : '권장시기'}
                          </Badge>
                        </div>
                        <div className="mb-2">
                          <div className="text-sm font-medium text-gray-900">{item.recommendation.service}</div>
                          <div className="text-xs text-gray-500">
                            목표: {item.recommendation.mileage.toLocaleString()}km
                          </div>
                        </div>
                        <Progress value={progress} className="h-2" />
                        <div className="text-xs text-gray-500 mt-1 text-right">
                          {progress.toFixed(0)}% 진행
                        </div>
                      </div>
                    );
                  })
                )}
                
                <Button className="w-full">
                  정비 예약하러 가기
                </Button>
              </CardContent>
            </Card>

            {/* Monthly Summary */}
            <Card className="bg-blue-50 border-blue-200">
              <CardHeader>
                <CardTitle className="text-blue-800">이번 달 요약</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  <div className="flex justify-between text-sm">
                    <span className="text-blue-700">정비 횟수</span>
                    <span className="font-medium text-blue-900">2회</span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span className="text-blue-700">정비 비용</span>
                    <span className="font-medium text-blue-900">150,000원</span>
                  </div>
                  <div className="pt-2 border-t border-blue-200">
                    <p className="text-xs text-blue-600">
                      💡 지난 달 대비 정비 비용이 20% 감소했습니다.
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  );
}