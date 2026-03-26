import { CheckCircle, Circle, Clock } from "lucide-react";

interface Step {
  id: string;
  title: string;
  description?: string;
  status: 'completed' | 'current' | 'upcoming';
}

interface StepIndicatorProps {
  steps: Step[];
  className?: string;
}

export function StepIndicator({ steps, className = "" }: StepIndicatorProps) {
  return (
    <div className={`w-full ${className}`}>
      <div className="flex items-center justify-between">
        {steps.map((step, index) => (
          <div key={step.id} className="flex items-center flex-1">
            <div className="flex flex-col items-center">
              {/* Step Icon */}
              <div className={`flex items-center justify-center w-10 h-10 rounded-full border-2 transition-all duration-300 ${
                step.status === 'completed' 
                  ? 'bg-success border-success text-white' 
                  : step.status === 'current'
                  ? 'bg-secondary border-secondary text-white animate-pulse'
                  : 'bg-white border-gray-300 text-gray-400'
              }`}>
                {step.status === 'completed' ? (
                  <CheckCircle className="w-5 h-5" />
                ) : step.status === 'current' ? (
                  <Clock className="w-5 h-5" />
                ) : (
                  <Circle className="w-5 h-5" />
                )}
              </div>
              
              {/* Step Content */}
              <div className="mt-3 text-center">
                <div className={`text-sm font-medium ${
                  step.status === 'completed' || step.status === 'current'
                    ? 'text-gray-900'
                    : 'text-gray-500'
                }`}>
                  {step.title}
                </div>
                {step.description && (
                  <div className="text-xs text-gray-500 mt-1">
                    {step.description}
                  </div>
                )}
              </div>
            </div>
            
            {/* Connection Line */}
            {index < steps.length - 1 && (
              <div className={`flex-1 h-0.5 mx-4 ${
                steps[index + 1].status === 'completed' || step.status === 'completed'
                  ? 'bg-success'
                  : step.status === 'current'
                  ? 'bg-gradient-to-r from-secondary to-gray-300'
                  : 'bg-gray-300'
              }`}></div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}