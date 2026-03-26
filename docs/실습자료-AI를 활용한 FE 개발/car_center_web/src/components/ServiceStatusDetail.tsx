import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { Avatar, AvatarFallback, AvatarImage } from "./ui/avatar";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "./ui/dialog";
import { ProgressBar } from "./ProgressBar";
import { StepIndicator } from "./StepIndicator";
import { 
  RefreshCw, 
  MessageCircle, 
  Camera, 
  AlertTriangle, 
  Clock, 
  User,
  Phone,
  CheckCircle2,
  XCircle,
  Eye
} from "lucide-react";
import { ImageWithFallback } from "./figma/ImageWithFallback";

interface ServiceStatusDetailProps {}

export function ServiceStatusDetail({}: ServiceStatusDetailProps) {
  const [isApprovalModalOpen, setIsApprovalModalOpen] = useState(false);
  const [isImageModalOpen, setIsImageModalOpen] = useState(false);
  const [selectedImage, setSelectedImage] = useState("");

  // Mock data
  const serviceInfo = {
    reservationNumber: "CR240123",
    vehicleInfo: "현대 아반떼 (123가4567)",
    progress: 70,
    estimatedCompletion: "16:30",
    currentTime: "15:45"
  };

  const steps = [
    {
      id: "receive",
      title: "접수",
      description: "14:00 완료",
      status: "completed" as const
    },
    {
      id: "diagnosis", 
      title: "진단",
      description: "14:30 완료",
      status: "completed" as const
    },
    {
      id: "work",
      title: "작업",
      description: "진행중",
      status: "current" as const
    },
    {
      id: "complete",
      title: "완료",
      description: "예정 16:30",
      status: "upcoming" as const
    }
  ];

  const currentWork = {
    title: "브레이크 패드 교체",
    description: "앞바퀴 양쪽 브레이크 패드 교체 작업 중입니다",
    technician: {
      name: "김정비",
      experience: "15년 경력",
      avatar: "/api/placeholder/40/40"
    },
    images: [
      "/api/placeholder/300/200",
      "/api/placeholder/300/200"
    ],
    startTime: "15:00",
    estimatedDuration: "1시간 30분"
  };

  const approvalRequest = {
    issue: "에어컨 필터 교체 필요",
    description: "정기 점검 중 에어컨 필터가 심하게 오염된 상태를 발견했습니다. 교체를 권장합니다.",
    price: 45000,
    originalPrice: 55000,
    images: ["/api/placeholder/300/200"]
  };

  const notifications = [
    {
      id: 1,
      time: "15:45",
      message: "브레이크 패드 교체 작업이 70% 완료되었습니다.",
      type: "progress",
      icon: Clock
    },
    {
      id: 2,
      time: "15:30",
      message: "에어컨 필터 교체 승인이 필요합니다.",
      type: "approval",
      icon: AlertTriangle
    },
    {
      id: 3,
      time: "15:00",
      message: "브레이크 패드 교체 작업을 시작했습니다.",
      type: "start",
      icon: CheckCircle2
    },
    {
      id: 4,
      time: "14:30",
      message: "차량 진단이 완료되었습니다.",
      type: "complete",
      icon: CheckCircle2
    }
  ];

  const openImageModal = (image: string) => {
    setSelectedImage(image);
    setIsImageModalOpen(true);
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex justify-between items-start mb-6">
            <div>
              <h1 className="text-2xl font-bold text-gray-900">실시간 정비 현황</h1>
              <p className="text-gray-600 mt-1">
                예약번호: <span className="font-medium text-primary">{serviceInfo.reservationNumber}</span> | 
                차량: <span className="font-medium">{serviceInfo.vehicleInfo}</span>
              </p>
            </div>
            <div className="flex gap-3">
              <Button variant="outline" size="sm">
                <RefreshCw className="w-4 h-4 mr-2" />
                새로고침
              </Button>
              <Button size="sm" className="bg-primary hover:bg-primary/90">
                <MessageCircle className="w-4 h-4 mr-2" />
                문의하기
              </Button>
            </div>
          </div>

          {/* Progress Header */}
          <div className="bg-gradient-to-r from-blue-50 to-orange-50 rounded-xl p-6 mb-6">
            <div className="grid md:grid-cols-2 gap-6 items-center">
              <div>
                <ProgressBar progress={serviceInfo.progress} />
              </div>
              <div className="text-center md:text-right">
                <div className="text-sm text-gray-600">예상 완료시간</div>
                <div className="text-2xl font-bold text-primary">{serviceInfo.estimatedCompletion}</div>
                <div className="text-sm text-gray-500">현재 {serviceInfo.currentTime}</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8">
        {/* Step Indicator */}
        <Card className="card-shadow border-0">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Clock className="w-5 h-5 text-primary" />
              진행 단계
            </CardTitle>
          </CardHeader>
          <CardContent>
            <StepIndicator steps={steps} />
          </CardContent>
        </Card>

        {/* Current Work */}
        <Card className="card-shadow border-0">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <User className="w-5 h-5 text-secondary" />
              현재 작업 중
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-6">
            <div className="bg-secondary/10 rounded-lg p-4">
              <div className="flex items-start justify-between mb-3">
                <div>
                  <h3 className="font-semibold text-gray-900">{currentWork.title}</h3>
                  <p className="text-gray-600 mt-1">{currentWork.description}</p>
                </div>
                <Badge className="bg-secondary text-white">
                  진행중
                </Badge>
              </div>
              <div className="flex items-center justify-between text-sm text-gray-500">
                <span>시작시간: {currentWork.startTime}</span>
                <span>예상소요: {currentWork.estimatedDuration}</span>
              </div>
            </div>

            {/* Technician Info */}
            <div className="flex items-center gap-4 p-4 bg-gray-50 rounded-lg">
              <Avatar className="w-12 h-12">
                <AvatarImage src={currentWork.technician.avatar} />
                <AvatarFallback className="bg-primary/10 text-primary">
                  {currentWork.technician.name.charAt(0)}
                </AvatarFallback>
              </Avatar>
              <div className="flex-1">
                <div className="font-medium text-gray-900">{currentWork.technician.name}</div>
                <div className="text-sm text-gray-600">{currentWork.technician.experience}</div>
              </div>
              <Button variant="outline" size="sm">
                <Phone className="w-4 h-4 mr-2" />
                연락하기
              </Button>
            </div>

            {/* Work Images */}
            <div>
              <h4 className="font-medium text-gray-900 mb-3 flex items-center gap-2">
                <Camera className="w-4 h-4" />
                실시간 작업 사진
              </h4>
              <div className="grid grid-cols-2 gap-4">
                {currentWork.images.map((image, index) => (
                  <div 
                    key={index}
                    className="relative cursor-pointer group"
                    onClick={() => openImageModal(image)}
                  >
                    <ImageWithFallback 
                      src={image}
                      alt={`작업 사진 ${index + 1}`}
                      className="w-full h-32 object-cover rounded-lg"
                    />
                    <div className="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity rounded-lg flex items-center justify-center">
                      <Eye className="w-6 h-6 text-white" />
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Approval Request */}
        <Card className="card-shadow border-0 border-l-4 border-l-warning">
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-warning">
              <AlertTriangle className="w-5 h-5" />
              추가 승인 요청
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="bg-warning/10 rounded-lg p-4">
              <h3 className="font-semibold text-gray-900 mb-2">{approvalRequest.issue}</h3>
              <p className="text-gray-600 mb-4">{approvalRequest.description}</p>
              
              <div className="flex items-center gap-4 mb-4">
                <div className="text-center">
                  <div className="text-sm text-gray-500">기존 가격</div>
                  <div className="text-lg line-through text-gray-400">
                    {approvalRequest.originalPrice.toLocaleString()}원
                  </div>
                </div>
                <div className="text-center">
                  <div className="text-sm text-gray-500">할인 가격</div>
                  <div className="text-xl font-bold text-secondary">
                    {approvalRequest.price.toLocaleString()}원
                  </div>
                </div>
              </div>
              
              <div className="flex gap-3">
                <Button 
                  className="flex-1 bg-success hover:bg-success/90 text-white"
                  onClick={() => setIsApprovalModalOpen(true)}
                >
                  <CheckCircle2 className="w-4 h-4 mr-2" />
                  승인하기
                </Button>
                <Button variant="outline" className="flex-1 border-error text-error hover:bg-error/5">
                  <XCircle className="w-4 h-4 mr-2" />
                  거부하기
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Real-time Notifications */}
        <Card className="card-shadow border-0">
          <CardHeader>
            <CardTitle>실시간 알림</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {notifications.map((notification) => {
                const IconComponent = notification.icon;
                return (
                  <div key={notification.id} className="flex items-start gap-3 p-3 rounded-lg hover:bg-gray-50 transition-colors">
                    <div className={`flex items-center justify-center w-8 h-8 rounded-full ${
                      notification.type === 'progress' ? 'bg-primary/10 text-primary' :
                      notification.type === 'approval' ? 'bg-warning/10 text-warning' :
                      notification.type === 'start' ? 'bg-secondary/10 text-secondary' :
                      'bg-success/10 text-success'
                    }`}>
                      <IconComponent className="w-4 h-4" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-gray-900">{notification.message}</p>
                      <p className="text-sm text-gray-500 mt-1">{notification.time}</p>
                    </div>
                  </div>
                );
              })}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Approval Modal */}
      <Dialog open={isApprovalModalOpen} onOpenChange={setIsApprovalModalOpen}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>추가 작업 승인</DialogTitle>
            <DialogDescription>
              {approvalRequest.issue}에 대한 상세 견적을 확인하고 승인해주세요.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div className="bg-gray-50 rounded-lg p-4">
              <h4 className="font-medium text-gray-900 mb-2">작업 내용</h4>
              <p className="text-gray-600">{approvalRequest.description}</p>
            </div>
            <div className="flex justify-between items-center p-4 bg-secondary/10 rounded-lg">
              <span className="font-medium text-gray-900">총 비용</span>
              <span className="text-xl font-bold text-secondary">
                {approvalRequest.price.toLocaleString()}원
              </span>
            </div>
          </div>
          <DialogFooter className="gap-2">
            <Button variant="outline" onClick={() => setIsApprovalModalOpen(false)}>
              취소
            </Button>
            <Button 
              className="bg-success hover:bg-success/90 text-white"
              onClick={() => setIsApprovalModalOpen(false)}
            >
              승인하기
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Image Modal */}
      <Dialog open={isImageModalOpen} onOpenChange={setIsImageModalOpen}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>작업 사진</DialogTitle>
          </DialogHeader>
          <div className="mt-4">
            <ImageWithFallback 
              src={selectedImage}
              alt="작업 사진 상세"
              className="w-full h-auto rounded-lg"
            />
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}