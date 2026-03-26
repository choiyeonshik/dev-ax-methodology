import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./ui/tabs";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "./ui/select";
import { Input } from "./ui/input";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "./ui/dialog";
import { 
  Calendar,
  Clock,
  Car,
  Filter,
  Search,
  Edit,
  X,
  Eye,
  MapPin,
  Phone,
  AlertCircle,
  CheckCircle2,
  Clock3,
  XCircle
} from "lucide-react";

interface Booking {
  id: string;
  bookingNumber: string;
  services: string[];
  vehicle: {
    licensePlate: string;
    model: string;
  };
  dateTime: {
    date: string;
    time: string;
  };
  status: 'scheduled' | 'in-progress' | 'completed' | 'cancelled';
  totalPrice: number;
  location: string;
  phone: string;
}

interface BookingManagementProps {}

export function BookingManagement({}: BookingManagementProps) {
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [dateFilter, setDateFilter] = useState<string>('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedBooking, setSelectedBooking] = useState<Booking | null>(null);

  // Mock booking data
  const bookings: Booking[] = [
    {
      id: '1',
      bookingNumber: 'BK-2024-001',
      services: ['엔진오일 교체', '타이어 점검'],
      vehicle: { licensePlate: '12가3456', model: '현대 아반떄' },
      dateTime: { date: '2024년 12월 15일 (일)', time: '10:00' },
      status: 'scheduled',
      totalPrice: 85000,
      location: '강남점',
      phone: '02-1234-5678'
    },
    {
      id: '2',
      bookingNumber: 'BK-2024-002',
      services: ['정기점검', '브레이크 패드 교체'],
      vehicle: { licensePlate: '78나9012', model: '기아 K5' },
      dateTime: { date: '2024년 12월 12일 (목)', time: '14:00' },
      status: 'in-progress',
      totalPrice: 150000,
      location: '서초점',
      phone: '02-2345-6789'
    },
    {
      id: '3',
      bookingNumber: 'BK-2024-003',
      services: ['에어컨 점검'],
      vehicle: { licensePlate: '34다5678', model: '현대 소나타' },
      dateTime: { date: '2024년 12월 08일 (일)', time: '09:00' },
      status: 'completed',
      totalPrice: 45000,
      location: '강남점',
      phone: '02-1234-5678'
    },
    {
      id: '4',
      bookingNumber: 'BK-2024-004',
      services: ['차량검사'],
      vehicle: { licensePlate: '56라7890', model: '기아 쏘렌토' },
      dateTime: { date: '2024년 12월 05일 (목)', time: '16:00' },
      status: 'cancelled',
      totalPrice: 80000,
      location: '서초점',
      phone: '02-2345-6789'
    }
  ];

  const getStatusConfig = (status: string) => {
    switch (status) {
      case 'scheduled':
        return { 
          label: '예약됨', 
          color: 'bg-primary/10 text-primary border-primary/20', 
          icon: <Calendar className="w-4 h-4" /> 
        };
      case 'in-progress':
        return { 
          label: '진행중', 
          color: 'bg-secondary/10 text-secondary border-secondary/20', 
          icon: <Clock3 className="w-4 h-4" /> 
        };
      case 'completed':
        return { 
          label: '완료', 
          color: 'bg-success/10 text-success border-success/20', 
          icon: <CheckCircle2 className="w-4 h-4" /> 
        };
      case 'cancelled':
        return { 
          label: '취소됨', 
          color: 'bg-gray-100 text-gray-600 border-gray-200', 
          icon: <XCircle className="w-4 h-4" /> 
        };
      default:
        return { 
          label: '알 수 없음', 
          color: 'bg-gray-100 text-gray-600 border-gray-200', 
          icon: <AlertCircle className="w-4 h-4" /> 
        };
    }
  };

  const filteredBookings = bookings.filter(booking => {
    const matchesStatus = statusFilter === 'all' || booking.status === statusFilter;
    const matchesSearch = searchQuery === '' || 
      booking.bookingNumber.toLowerCase().includes(searchQuery.toLowerCase()) ||
      booking.vehicle.licensePlate.includes(searchQuery) ||
      booking.services.some(service => service.toLowerCase().includes(searchQuery.toLowerCase()));
    
    let matchesDate = true;
    if (dateFilter === 'today') {
      const today = new Date().toISOString().split('T')[0];
      matchesDate = booking.dateTime.date.includes(today);
    } else if (dateFilter === 'week') {
      // Mock logic for this week
      matchesDate = ['12월 15일', '12월 12일'].some(date => booking.dateTime.date.includes(date));
    }
    
    return matchesStatus && matchesSearch && matchesDate;
  });

  const currentBookings = filteredBookings.filter(booking => 
    booking.status === 'scheduled' || booking.status === 'in-progress'
  );
  
  const pastBookings = filteredBookings.filter(booking => 
    booking.status === 'completed' || booking.status === 'cancelled'
  );

  const handleCancelBooking = (bookingId: string) => {
    if (confirm('정말로 예약을 취소하시겠습니까?')) {
      alert('예약이 취소되었습니다.');
      // In real app, this would update the booking status
    }
  };

  const BookingCard = ({ booking }: { booking: Booking }) => {
    const statusConfig = getStatusConfig(booking.status);
    
    return (
      <Card className="hover:shadow-lg transition-shadow duration-200 border-0 card-shadow">
        <CardContent className="p-6">
          <div className="flex items-start justify-between mb-4">
            <div className="flex items-center gap-3">
              <Badge 
                variant="outline" 
                className={`${statusConfig.color} px-3 py-1 flex items-center gap-2`}
              >
                {statusConfig.icon}
                {statusConfig.label}
              </Badge>
              <span className="text-sm text-gray-500">#{booking.bookingNumber}</span>
            </div>
            <div className="text-right">
              <div className="font-bold text-primary">{booking.totalPrice.toLocaleString()}원</div>
              <div className="text-sm text-gray-500">{booking.location}</div>
            </div>
          </div>

          <div className="grid md:grid-cols-2 gap-4 mb-4">
            <div>
              <div className="flex items-center gap-2 mb-2">
                <Car className="w-4 h-4 text-gray-500" />
                <span className="text-sm text-gray-600">차량 정보</span>
              </div>
              <div className="ml-6">
                <div className="font-medium">{booking.vehicle.licensePlate}</div>
                <div className="text-sm text-gray-500">{booking.vehicle.model}</div>
              </div>
            </div>
            
            <div>
              <div className="flex items-center gap-2 mb-2">
                <Calendar className="w-4 h-4 text-gray-500" />
                <span className="text-sm text-gray-600">예약 일시</span>
              </div>
              <div className="ml-6">
                <div className="font-medium">{booking.dateTime.date}</div>
                <div className="text-sm text-gray-500">{booking.dateTime.time}</div>
              </div>
            </div>
          </div>

          <div className="mb-4">
            <div className="flex items-center gap-2 mb-2">
              <CheckCircle2 className="w-4 h-4 text-gray-500" />
              <span className="text-sm text-gray-600">선택된 서비스</span>
            </div>
            <div className="ml-6 flex flex-wrap gap-2">
              {booking.services.map((service, index) => (
                <Badge key={index} variant="secondary" className="bg-gray-100 text-gray-700">
                  {service}
                </Badge>
              ))}
            </div>
          </div>

          <div className="flex items-center justify-between pt-4 border-t border-gray-200">
            <div className="flex items-center gap-4 text-sm text-gray-600">
              <div className="flex items-center gap-1">
                <MapPin className="w-4 h-4" />
                {booking.location}
              </div>
              <div className="flex items-center gap-1">
                <Phone className="w-4 h-4" />
                {booking.phone}
              </div>
            </div>
            
            <div className="flex items-center gap-2">
              <Dialog>
                <DialogTrigger asChild>
                  <Button 
                    variant="ghost" 
                    size="sm"
                    onClick={() => setSelectedBooking(booking)}
                  >
                    <Eye className="w-4 h-4 mr-1" />
                    상세보기
                  </Button>
                </DialogTrigger>
                <DialogContent className="sm:max-w-md">
                  <DialogHeader>
                    <DialogTitle>예약 상세 정보</DialogTitle>
                  </DialogHeader>
                  {selectedBooking && (
                    <div className="space-y-4">
                      <div className="grid grid-cols-2 gap-4 text-sm">
                        <div>
                          <span className="text-gray-600">예약 번호:</span>
                          <p className="font-medium">{selectedBooking.bookingNumber}</p>
                        </div>
                        <div>
                          <span className="text-gray-600">상태:</span>
                          <p className="font-medium">{getStatusConfig(selectedBooking.status).label}</p>
                        </div>
                        <div>
                          <span className="text-gray-600">차량:</span>
                          <p className="font-medium">
                            {selectedBooking.vehicle.licensePlate}<br/>
                            {selectedBooking.vehicle.model}
                          </p>
                        </div>
                        <div>
                          <span className="text-gray-600">일시:</span>
                          <p className="font-medium">
                            {selectedBooking.dateTime.date}<br/>
                            {selectedBooking.dateTime.time}
                          </p>
                        </div>
                        <div className="col-span-2">
                          <span className="text-gray-600">서비스:</span>
                          <p className="font-medium">{selectedBooking.services.join(', ')}</p>
                        </div>
                        <div>
                          <span className="text-gray-600">지점:</span>
                          <p className="font-medium">{selectedBooking.location}</p>
                        </div>
                        <div>
                          <span className="text-gray-600">연락처:</span>
                          <p className="font-medium">{selectedBooking.phone}</p>
                        </div>
                      </div>
                    </div>
                  )}
                </DialogContent>
              </Dialog>
              
              {booking.status === 'scheduled' && (
                <>
                  <Button variant="outline" size="sm">
                    <Edit className="w-4 h-4 mr-1" />
                    수정
                  </Button>
                  <Button 
                    variant="outline" 
                    size="sm" 
                    onClick={() => handleCancelBooking(booking.id)}
                    className="text-red-600 hover:text-red-700 hover:border-red-200"
                  >
                    <X className="w-4 h-4 mr-1" />
                    취소
                  </Button>
                </>
              )}
            </div>
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
          <div>
            <h1 className="text-2xl font-bold text-gray-900">예약 관리</h1>
            <p className="text-gray-600 mt-1">나의 정비 예약을 관리하세요</p>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Filters */}
        <Card className="mb-8 card-shadow border-0">
          <CardContent className="p-6">
            <div className="flex items-center gap-4 mb-4">
              <Filter className="w-5 h-5 text-gray-500" />
              <h3 className="font-medium text-gray-900">필터</h3>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div>
                <label className="block text-sm text-gray-600 mb-2">상태</label>
                <Select value={statusFilter} onValueChange={setStatusFilter}>
                  <SelectTrigger>
                    <SelectValue placeholder="상태 선택" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">전체</SelectItem>
                    <SelectItem value="scheduled">예약됨</SelectItem>
                    <SelectItem value="in-progress">진행중</SelectItem>
                    <SelectItem value="completed">완료</SelectItem>
                    <SelectItem value="cancelled">취소됨</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              
              <div>
                <label className="block text-sm text-gray-600 mb-2">기간</label>
                <Select value={dateFilter} onValueChange={setDateFilter}>
                  <SelectTrigger>
                    <SelectValue placeholder="기간 선택" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">전체</SelectItem>
                    <SelectItem value="today">오늘</SelectItem>
                    <SelectItem value="week">이번 주</SelectItem>
                    <SelectItem value="month">이번 달</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              
              <div className="md:col-span-2">
                <label className="block text-sm text-gray-600 mb-2">검색</label>
                <div className="relative">
                  <Search className="w-4 h-4 text-gray-500 absolute left-3 top-1/2 transform -translate-y-1/2" />
                  <Input
                    placeholder="예약번호, 차량번호, 서비스명으로 검색"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="pl-10"
                  />
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Tabs */}
        <Tabs defaultValue="current" className="space-y-6">
          <TabsList className="grid w-full max-w-md grid-cols-2">
            <TabsTrigger value="current" className="flex items-center gap-2">
              <Clock className="w-4 h-4" />
              현재 예약 ({currentBookings.length})
            </TabsTrigger>
            <TabsTrigger value="past" className="flex items-center gap-2">
              <CheckCircle2 className="w-4 h-4" />
              지난 예약 ({pastBookings.length})
            </TabsTrigger>
          </TabsList>

          <TabsContent value="current" className="space-y-4">
            {currentBookings.length === 0 ? (
              <Card className="card-shadow border-0">
                <CardContent className="p-12 text-center">
                  <Calendar className="w-12 h-12 text-gray-400 mx-auto mb-4" />
                  <h3 className="text-lg font-medium text-gray-900 mb-2">현재 예약이 없습니다</h3>
                  <p className="text-gray-600">새로운 정비 예약을 진행해보세요.</p>
                  <Button className="mt-4">
                    예약하러 가기
                  </Button>
                </CardContent>
              </Card>
            ) : (
              currentBookings.map(booking => (
                <BookingCard key={booking.id} booking={booking} />
              ))
            )}
          </TabsContent>

          <TabsContent value="past" className="space-y-4">
            {pastBookings.length === 0 ? (
              <Card className="card-shadow border-0">
                <CardContent className="p-12 text-center">
                  <CheckCircle2 className="w-12 h-12 text-gray-400 mx-auto mb-4" />
                  <h3 className="text-lg font-medium text-gray-900 mb-2">지난 예약이 없습니다</h3>
                  <p className="text-gray-600">아직 완료된 예약이 없습니다.</p>
                </CardContent>
              </Card>
            ) : (
              pastBookings.map(booking => (
                <BookingCard key={booking.id} booking={booking} />
              ))
            )}
          </TabsContent>
        </Tabs>
      </div>
    </div>
  );
}