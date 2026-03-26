import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { 
  ArrowLeft,
  ArrowRight,
  ChevronLeft,
  ChevronRight,
  Calendar,
  Clock,
  Users,
  CheckCircle2
} from "lucide-react";

interface SelectedService {
  id: string;
  name: string;
  price: number;
  duration: string;
}

interface DateTimeSelectionProps {
  selectedServices: SelectedService[];
  onBack: () => void;
  onNext: (dateTime: { date: string; time: string }) => void;
}

interface TimeSlot {
  id: string;
  time: string;
  period: 'morning' | 'afternoon';
  available: boolean;
  capacity: 'available' | 'limited' | 'full';
}

export function DateTimeSelection({ selectedServices, onBack, onNext }: DateTimeSelectionProps) {
  const [currentDate, setCurrentDate] = useState(new Date());
  const [selectedDate, setSelectedDate] = useState<Date | null>(null);
  const [selectedTimeSlot, setSelectedTimeSlot] = useState<string | null>(null);

  // Generate calendar dates
  const generateCalendarDates = (date: Date) => {
    const year = date.getFullYear();
    const month = date.getMonth();
    const firstDay = new Date(year, month, 1);
    const lastDay = new Date(year, month + 1, 0);
    const startDate = new Date(firstDay);
    startDate.setDate(startDate.getDate() - firstDay.getDay());
    
    const dates = [];
    for (let i = 0; i < 42; i++) {
      const currentDate = new Date(startDate);
      currentDate.setDate(startDate.getDate() + i);
      dates.push(currentDate);
    }
    return dates;
  };

  const calendarDates = generateCalendarDates(currentDate);

  // Mock data for available dates (in real app, this would come from API)
  const isDateAvailable = (date: Date) => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const targetDate = new Date(date);
    targetDate.setHours(0, 0, 0, 0);
    
    // Can't book past dates or Sundays
    if (targetDate < today || date.getDay() === 0) return false;
    
    // Mock: make some random dates unavailable
    const dateStr = date.toDateString();
    return !['Sat Dec 07 2024', 'Mon Dec 16 2024', 'Thu Dec 26 2024'].includes(dateStr);
  };

  const timeSlots: TimeSlot[] = [
    { id: '09:00', time: '09:00', period: 'morning', available: true, capacity: 'available' },
    { id: '10:00', time: '10:00', period: 'morning', available: true, capacity: 'available' },
    { id: '11:00', time: '11:00', period: 'morning', available: true, capacity: 'limited' },
    { id: '14:00', time: '14:00', period: 'afternoon', available: true, capacity: 'available' },
    { id: '15:00', time: '15:00', period: 'afternoon', available: true, capacity: 'limited' },
    { id: '16:00', time: '16:00', period: 'afternoon', available: true, capacity: 'full' },
    { id: '17:00', time: '17:00', period: 'afternoon', available: true, capacity: 'available' },
    { id: '18:00', time: '18:00', period: 'afternoon', available: false, capacity: 'full' },
  ];

  const availableTimeSlots = selectedDate ? timeSlots.filter(slot => slot.available) : [];
  const morningSlots = availableTimeSlots.filter(slot => slot.period === 'morning');
  const afternoonSlots = availableTimeSlots.filter(slot => slot.period === 'afternoon');

  const navigateMonth = (direction: 'prev' | 'next') => {
    setCurrentDate(prev => {
      const newDate = new Date(prev);
      if (direction === 'prev') {
        newDate.setMonth(prev.getMonth() - 1);
      } else {
        newDate.setMonth(prev.getMonth() + 1);
      }
      return newDate;
    });
  };

  const formatDate = (date: Date) => {
    return date.toLocaleDateString('ko-KR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      weekday: 'long'
    });
  };

  const getCapacityInfo = (capacity: string) => {
    switch (capacity) {
      case 'available':
        return { text: '여유', color: 'bg-success/10 text-success' };
      case 'limited':
        return { text: '보통', color: 'bg-warning/10 text-warning' };
      case 'full':
        return { text: '마감임박', color: 'bg-error/10 text-error' };
      default:
        return { text: '불가', color: 'bg-gray-100 text-gray-500' };
    }
  };

  const getTotalPrice = () => {
    return selectedServices.reduce((total, service) => total + service.price, 0);
  };

  const isDateSelected = (date: Date) => {
    if (!selectedDate) return false;
    return date.toDateString() === selectedDate.toDateString();
  };

  const isCurrentMonth = (date: Date) => {
    return date.getMonth() === currentDate.getMonth();
  };

  const isToday = (date: Date) => {
    const today = new Date();
    return date.toDateString() === today.toDateString();
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
              <h1 className="text-2xl font-bold text-gray-900">날짜 & 시간 선택</h1>
              <p className="text-gray-600 mt-1">편리한 시간을 선택해주세요</p>
            </div>
          </div>

          {/* Progress Steps */}
          <div className="bg-gradient-to-r from-blue-50 to-orange-50 rounded-xl p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="text-sm font-medium text-gray-600">예약 진행 단계</div>
              <div className="text-sm text-primary font-medium">2/4 단계</div>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center text-white font-medium text-sm">
                ✓
              </div>
              <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center text-white font-medium text-sm">
                2
              </div>
              <div className="flex-1 h-1 bg-gray-200 rounded-full">
                <div className="w-2/4 h-1 bg-gradient-to-r from-primary to-secondary rounded-full"></div>
              </div>
              <div className="text-sm font-medium text-primary">날짜 & 시간 선택</div>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid lg:grid-cols-3 gap-8">
          {/* Calendar Section */}
          <div className="lg:col-span-2 space-y-6">
            <Card className="card-shadow border-0">
              <CardHeader>
                <div className="flex items-center justify-between">
                  <CardTitle className="flex items-center gap-2">
                    <Calendar className="w-5 h-5 text-primary" />
                    날짜 선택
                  </CardTitle>
                  <div className="flex items-center gap-2">
                    <Button 
                      variant="ghost" 
                      size="sm"
                      onClick={() => navigateMonth('prev')}
                    >
                      <ChevronLeft className="w-4 h-4" />
                    </Button>
                    <div className="font-medium min-w-[120px] text-center">
                      {currentDate.toLocaleDateString('ko-KR', { year: 'numeric', month: 'long' })}
                    </div>
                    <Button 
                      variant="ghost" 
                      size="sm"
                      onClick={() => navigateMonth('next')}
                    >
                      <ChevronRight className="w-4 h-4" />
                    </Button>
                  </div>
                </div>
              </CardHeader>
              <CardContent>
                {/* Calendar Grid */}
                <div className="grid grid-cols-7 gap-1 mb-2">
                  {['일', '월', '화', '수', '목', '금', '토'].map(day => (
                    <div key={day} className="p-2 text-center text-sm font-medium text-gray-500">
                      {day}
                    </div>
                  ))}
                </div>
                <div className="grid grid-cols-7 gap-1">
                  {calendarDates.map((date, index) => {
                    const available = isDateAvailable(date);
                    const selected = isDateSelected(date);
                    const currentMonth = isCurrentMonth(date);
                    const today = isToday(date);
                    
                    return (
                      <button
                        key={index}
                        onClick={() => available && currentMonth ? setSelectedDate(date) : null}
                        disabled={!available || !currentMonth}
                        className={`
                          p-2 h-10 text-sm rounded-lg transition-all duration-200 relative
                          ${!currentMonth ? 'text-gray-300 cursor-not-allowed' :
                            !available ? 'text-gray-400 cursor-not-allowed' :
                            selected ? 'bg-secondary text-white font-medium scale-105' :
                            today ? 'bg-primary/10 text-primary font-medium border border-primary' :
                            'text-gray-900 hover:bg-primary/5 hover:text-primary cursor-pointer'
                          }
                        `}
                      >
                        {date.getDate()}
                        {today && !selected && (
                          <div className="absolute -bottom-1 left-1/2 transform -translate-x-1/2 w-1 h-1 bg-primary rounded-full"></div>
                        )}
                      </button>
                    );
                  })}
                </div>
                
                {/* Legend */}
                <div className="flex flex-wrap gap-4 mt-4 pt-4 border-t border-gray-200 text-xs">
                  <div className="flex items-center gap-2">
                    <div className="w-3 h-3 bg-primary rounded"></div>
                    <span className="text-gray-600">선택 가능</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-3 h-3 bg-secondary rounded"></div>
                    <span className="text-gray-600">선택됨</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-3 h-3 bg-gray-300 rounded"></div>
                    <span className="text-gray-600">선택 불가</span>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Time Selection */}
            {selectedDate && (
              <Card className="card-shadow border-0">
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Clock className="w-5 h-5 text-secondary" />
                    시간 선택
                    <Badge variant="outline" className="ml-2">
                      {formatDate(selectedDate)}
                    </Badge>
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-6">
                  {/* Morning Slots */}
                  {morningSlots.length > 0 && (
                    <div>
                      <h4 className="font-medium text-gray-900 mb-3 flex items-center gap-2">
                        ☀️ 오전 ({morningSlots.length}개 시간대)
                      </h4>
                      <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
                        {morningSlots.map(slot => {
                          const capacity = getCapacityInfo(slot.capacity);
                          const isSelected = selectedTimeSlot === slot.id;
                          
                          return (
                            <button
                              key={slot.id}
                              onClick={() => setSelectedTimeSlot(slot.id)}
                              className={`
                                p-3 rounded-lg border transition-all duration-200 text-left
                                ${isSelected 
                                  ? 'border-secondary bg-secondary/5 ring-2 ring-secondary/20' 
                                  : 'border-gray-200 hover:border-primary/50 hover:bg-primary/5'
                                }
                              `}
                            >
                              <div className="flex items-center justify-between mb-2">
                                <span className="font-medium text-gray-900">{slot.time}</span>
                                {isSelected && <CheckCircle2 className="w-4 h-4 text-secondary" />}
                              </div>
                              <Badge 
                                variant="outline" 
                                className={`text-xs ${capacity.color} border-0`}
                              >
                                <Users className="w-3 h-3 mr-1" />
                                {capacity.text}
                              </Badge>
                            </button>
                          );
                        })}
                      </div>
                    </div>
                  )}

                  {/* Afternoon Slots */}
                  {afternoonSlots.length > 0 && (
                    <div>
                      <h4 className="font-medium text-gray-900 mb-3 flex items-center gap-2">
                        🌅 오후 ({afternoonSlots.length}개 시간대)
                      </h4>
                      <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
                        {afternoonSlots.map(slot => {
                          const capacity = getCapacityInfo(slot.capacity);
                          const isSelected = selectedTimeSlot === slot.id;
                          
                          return (
                            <button
                              key={slot.id}
                              onClick={() => setSelectedTimeSlot(slot.id)}
                              disabled={slot.capacity === 'full'}
                              className={`
                                p-3 rounded-lg border transition-all duration-200 text-left
                                ${slot.capacity === 'full' 
                                  ? 'border-gray-200 bg-gray-50 cursor-not-allowed opacity-50'
                                  : isSelected 
                                  ? 'border-secondary bg-secondary/5 ring-2 ring-secondary/20' 
                                  : 'border-gray-200 hover:border-primary/50 hover:bg-primary/5'
                                }
                              `}
                            >
                              <div className="flex items-center justify-between mb-2">
                                <span className="font-medium text-gray-900">{slot.time}</span>
                                {isSelected && <CheckCircle2 className="w-4 h-4 text-secondary" />}
                              </div>
                              <Badge 
                                variant="outline" 
                                className={`text-xs ${capacity.color} border-0`}
                              >
                                <Users className="w-3 h-3 mr-1" />
                                {capacity.text}
                              </Badge>
                            </button>
                          );
                        })}
                      </div>
                    </div>
                  )}
                </CardContent>
              </Card>
            )}
          </div>

          {/* Summary Sidebar */}
          <div className="space-y-6">
            {/* Selected Services Summary */}
            <Card className="card-shadow border-0">
              <CardHeader>
                <CardTitle>선택된 서비스</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                {selectedServices.map(service => (
                  <div key={service.id} className="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
                    <div>
                      <div className="font-medium text-gray-900">{service.name}</div>
                      <div className="text-sm text-gray-500">{service.duration}</div>
                    </div>
                    <div className="font-medium text-primary">
                      {service.price.toLocaleString()}원
                    </div>
                  </div>
                ))}
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

            {/* Booking Summary */}
            {selectedDate && selectedTimeSlot && (
              <Card className="card-shadow border-0 border-l-4 border-l-secondary">
                <CardHeader>
                  <CardTitle className="text-secondary">예약 요약</CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="space-y-3">
                    <div className="flex items-center gap-2">
                      <Calendar className="w-4 h-4 text-gray-500" />
                      <span className="text-sm text-gray-600">예약 날짜</span>
                    </div>
                    <div className="font-medium text-gray-900 ml-6">
                      {formatDate(selectedDate)}
                    </div>
                  </div>
                  
                  <div className="space-y-3">
                    <div className="flex items-center gap-2">
                      <Clock className="w-4 h-4 text-gray-500" />
                      <span className="text-sm text-gray-600">예약 시간</span>
                    </div>
                    <div className="font-medium text-gray-900 ml-6">
                      {selectedTimeSlot}
                    </div>
                  </div>

                  <Button 
                    className="w-full btn-height bg-primary hover:bg-primary/90 mt-6"
                    onClick={() => onNext({ 
                      date: formatDate(selectedDate), 
                      time: selectedTimeSlot 
                    })}
                  >
                    다음 단계
                    <ArrowRight className="w-4 h-4 ml-2" />
                  </Button>
                </CardContent>
              </Card>
            )}

            {/* Help Text */}
            <Card className="bg-blue-50 border-blue-200">
              <CardContent className="p-4">
                <div className="text-sm text-blue-800">
                  <p className="font-medium mb-2">💡 예약 팁</p>
                  <ul className="space-y-1 text-blue-700">
                    <li>• 오전 시간대가 상대적으로 대기시간이 짧습니다</li>
                    <li>• 주말 예약은 빠르게 마감되니 미리 예약하세요</li>
                    <li>• 예약 변경은 1일 전까지 가능합니다</li>
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