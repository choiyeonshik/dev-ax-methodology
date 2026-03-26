import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "./ui/dialog";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { 
  ArrowLeft,
  ArrowRight,
  Car,
  Plus,
  CheckCircle2,
  Calendar,
  Gauge,
  Fuel,
  Settings,
  Upload,
  X
} from "lucide-react";

interface SelectedService {
  id: string;
  name: string;
  price: number;
  duration: string;
}

interface Vehicle {
  id: string;
  licensePlate: string;
  brand: string;
  model: string;
  year: number;
  mileage: number;
  fuelType: string;
  lastService?: string;
  image?: string;
}

interface VehicleInfoProps {
  selectedServices: SelectedService[];
  selectedDateTime: {
    date: string;
    time: string;
  };
  onBack: () => void;
  onNext: (selectedVehicle: Vehicle) => void;
}

export function VehicleInfo({ selectedServices, selectedDateTime, onBack, onNext }: VehicleInfoProps) {
  const [selectedVehicle, setSelectedVehicle] = useState<Vehicle | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [newVehicle, setNewVehicle] = useState({
    licensePlate: '',
    mileage: '',
    image: null as File | null
  });

  // Mock vehicle data
  const [vehicles, setVehicles] = useState<Vehicle[]>([
    {
      id: '1',
      licensePlate: '12가3456',
      brand: '현대',
      model: '아반떼',
      year: 2022,
      mileage: 35000,
      fuelType: '가솔린',
      lastService: '2024.10.15'
    },
    {
      id: '2',
      licensePlate: '78나9012',
      brand: '기아',
      model: 'K5',
      year: 2021,
      mileage: 48000,
      fuelType: '하이브리드',
      lastService: '2024.09.20'
    }
  ]);

  const getTotalPrice = () => {
    return selectedServices.reduce((total, service) => total + service.price, 0);
  };

  const getTotalDuration = () => {
    const totalMinutes = selectedServices.reduce((total, service) => {
      const duration = service.duration;
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

  const handleVehicleRegistration = () => {
    if (!newVehicle.licensePlate || !newVehicle.mileage) return;

    // Mock API call to get vehicle info
    const mockVehicleData: Vehicle = {
      id: Date.now().toString(),
      licensePlate: newVehicle.licensePlate,
      brand: '현대', // Mock data from license plate lookup
      model: '소나타',
      year: 2023,
      mileage: parseInt(newVehicle.mileage),
      fuelType: '가솔린'
    };

    setVehicles(prev => [...prev, mockVehicleData]);
    setSelectedVehicle(mockVehicleData);
    setNewVehicle({ licensePlate: '', mileage: '', image: null });
    setIsModalOpen(false);
  };

  const handleImageUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file) {
      setNewVehicle(prev => ({ ...prev, image: file }));
    }
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex items-center gap-4 mb-6">
            <Button variant="ghost" size="sm" onClick={onBack}>
              <ArrowLeft className="w-4 h-4 mr-2" />
              이전 단계
            </Button>
            <div>
              <h1 className="text-2xl font-bold text-gray-900">차량 정보</h1>
              <p className="text-gray-600 mt-1">정비받을 차량을 선택해주세요</p>
            </div>
          </div>

          {/* Progress Steps */}
          <div className="bg-gradient-to-r from-blue-50 to-orange-50 rounded-xl p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="text-sm font-medium text-gray-600">예약 진행 단계</div>
              <div className="text-sm text-primary font-medium">3/4 단계</div>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center text-white font-medium text-sm">
                ✓
              </div>
              <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center text-white font-medium text-sm">
                ✓
              </div>
              <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center text-white font-medium text-sm">
                3
              </div>
              <div className="flex-1 h-1 bg-gray-200 rounded-full">
                <div className="w-3/4 h-1 bg-gradient-to-r from-primary to-secondary rounded-full"></div>
              </div>
              <div className="text-sm font-medium text-primary">차량 정보</div>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid lg:grid-cols-3 gap-8">
          {/* Vehicle Selection */}
          <div className="lg:col-span-2 space-y-6">
            <div className="flex items-center justify-between">
              <h2 className="text-xl font-bold text-gray-900">등록된 차량</h2>
              <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
                <DialogTrigger asChild>
                  <Button variant="outline" className="flex items-center gap-2">
                    <Plus className="w-4 h-4" />
                    새 차량 등록
                  </Button>
                </DialogTrigger>
                <DialogContent className="sm:max-w-md">
                  <DialogHeader>
                    <DialogTitle>새 차량 등록</DialogTitle>
                  </DialogHeader>
                  <div className="space-y-4">
                    <div>
                      <Label htmlFor="licensePlate">차량번호</Label>
                      <Input
                        id="licensePlate"
                        placeholder="예: 12가3456"
                        value={newVehicle.licensePlate}
                        onChange={(e) => setNewVehicle(prev => ({ ...prev, licensePlate: e.target.value }))}
                        className="mt-1"
                      />
                      <p className="text-xs text-gray-500 mt-1">차량번호 입력 시 자동으로 차량 정보를 조회합니다</p>
                    </div>
                    <div>
                      <Label htmlFor="mileage">주행거리 (km)</Label>
                      <Input
                        id="mileage"
                        type="number"
                        placeholder="예: 50000"
                        value={newVehicle.mileage}
                        onChange={(e) => setNewVehicle(prev => ({ ...prev, mileage: e.target.value }))}
                        className="mt-1"
                      />
                    </div>
                    <div>
                      <Label htmlFor="vehicleImage">차량 사진 (선택)</Label>
                      <div className="mt-1 border-2 border-dashed border-gray-300 rounded-lg p-4 text-center hover:border-primary/50 transition-colors">
                        <input
                          id="vehicleImage"
                          type="file"
                          accept="image/*"
                          onChange={handleImageUpload}
                          className="hidden"
                        />
                        <label htmlFor="vehicleImage" className="cursor-pointer flex flex-col items-center gap-2">
                          <Upload className="w-6 h-6 text-gray-400" />
                          <span className="text-sm text-gray-600">
                            {newVehicle.image ? newVehicle.image.name : '클릭하여 사진 업로드'}
                          </span>
                        </label>
                      </div>
                    </div>
                    <div className="flex gap-3 pt-4">
                      <Button 
                        variant="outline" 
                        onClick={() => setIsModalOpen(false)}
                        className="flex-1"
                      >
                        취소
                      </Button>
                      <Button 
                        onClick={handleVehicleRegistration}
                        disabled={!newVehicle.licensePlate || !newVehicle.mileage}
                        className="flex-1"
                      >
                        등록하기
                      </Button>
                    </div>
                  </div>
                </DialogContent>
              </Dialog>
            </div>

            <div className="grid gap-4">
              {vehicles.map(vehicle => (
                <Card 
                  key={vehicle.id}
                  className={`cursor-pointer transition-all duration-200 hover:shadow-lg ${
                    selectedVehicle?.id === vehicle.id
                      ? 'ring-2 ring-primary bg-primary/5 border-primary'
                      : 'border-gray-200 hover:border-primary/50'
                  }`}
                  onClick={() => setSelectedVehicle(vehicle)}
                >
                  <CardContent className="p-6">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-4">
                        <div className={`p-3 rounded-lg ${
                          selectedVehicle?.id === vehicle.id 
                            ? 'bg-primary text-white' 
                            : 'bg-primary/10 text-primary'
                        }`}>
                          <Car className="w-6 h-6" />
                        </div>
                        <div>
                          <div className="flex items-center gap-3 mb-2">
                            <h3 className="font-bold text-lg text-gray-900">
                              {vehicle.licensePlate}
                            </h3>
                            {selectedVehicle?.id === vehicle.id && (
                              <CheckCircle2 className="w-5 h-5 text-primary" />
                            )}
                          </div>
                          <p className="text-gray-600 mb-2">
                            {vehicle.brand} {vehicle.model} ({vehicle.year}년)
                          </p>
                          <div className="flex items-center gap-4 text-sm text-gray-500">
                            <div className="flex items-center gap-1">
                              <Gauge className="w-4 h-4" />
                              {vehicle.mileage.toLocaleString()} km
                            </div>
                            <div className="flex items-center gap-1">
                              <Fuel className="w-4 h-4" />
                              {vehicle.fuelType}
                            </div>
                            {vehicle.lastService && (
                              <div className="flex items-center gap-1">
                                <Settings className="w-4 h-4" />
                                최근 정비: {vehicle.lastService}
                              </div>
                            )}
                          </div>
                        </div>
                      </div>
                      {selectedVehicle?.id === vehicle.id && (
                        <Badge className="bg-primary text-white">
                          선택됨
                        </Badge>
                      )}
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>

          {/* Summary Sidebar */}
          <div className="space-y-6">
            {/* Booking Summary */}
            <Card className="card-shadow border-0">
              <CardHeader>
                <CardTitle>예약 요약</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                {/* Services */}
                <div>
                  <h4 className="font-medium text-gray-900 mb-2">선택된 서비스</h4>
                  {selectedServices.map(service => (
                    <div key={service.id} className="flex justify-between items-center p-2 bg-gray-50 rounded text-sm">
                      <span>{service.name}</span>
                      <span className="font-medium">{service.price.toLocaleString()}원</span>
                    </div>
                  ))}
                </div>
                
                {/* Date & Time */}
                <div className="pt-3 border-t border-gray-200">
                  <h4 className="font-medium text-gray-900 mb-2">예약 일시</h4>
                  <div className="space-y-1 text-sm text-gray-600">
                    <div className="flex items-center gap-2">
                      <Calendar className="w-4 h-4" />
                      {selectedDateTime.date}
                    </div>
                    <div className="flex items-center gap-2">
                      <div className="w-4 h-4"></div>
                      {selectedDateTime.time} ({getTotalDuration()})
                    </div>
                  </div>
                </div>

                {/* Selected Vehicle */}
                {selectedVehicle && (
                  <div className="pt-3 border-t border-gray-200">
                    <h4 className="font-medium text-gray-900 mb-2">선택된 차량</h4>
                    <div className="p-3 bg-primary/5 rounded-lg text-sm">
                      <div className="font-medium text-primary">{selectedVehicle.licensePlate}</div>
                      <div className="text-gray-600">
                        {selectedVehicle.brand} {selectedVehicle.model} ({selectedVehicle.year}년)
                      </div>
                    </div>
                  </div>
                )}

                {/* Total */}
                <div className="pt-3 border-t border-gray-200">
                  <div className="flex justify-between items-center">
                    <span className="font-medium text-gray-900">총 금액</span>
                    <span className="text-lg font-bold text-primary">
                      {getTotalPrice().toLocaleString()}원
                    </span>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Next Button */}
            {selectedVehicle && (
              <Button 
                className="w-full btn-height bg-primary hover:bg-primary/90"
                onClick={() => onNext(selectedVehicle)}
              >
                다음 단계
                <ArrowRight className="w-4 h-4 ml-2" />
              </Button>
            )}

            {/* Help Text */}
            <Card className="bg-blue-50 border-blue-200">
              <CardContent className="p-4">
                <div className="text-sm text-blue-800">
                  <p className="font-medium mb-2">💡 차량 등록 안내</p>
                  <ul className="space-y-1 text-blue-700">
                    <li>• 차량번호로 자동 차량 정보 조회</li>
                    <li>• 정확한 주행거리 입력 필요</li>
                    <li>• 차량 사진은 선택사항입니다</li>
                  </ul>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  );
}