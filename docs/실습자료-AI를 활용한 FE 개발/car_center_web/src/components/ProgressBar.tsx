interface ProgressBarProps {
  progress: number;
  className?: string;
}

export function ProgressBar({ progress, className = "" }: ProgressBarProps) {
  return (
    <div className={`w-full ${className}`}>
      <div className="flex justify-between items-center mb-2">
        <span className="text-sm font-medium text-gray-700">전체 진행률</span>
        <span className="text-sm font-bold text-primary">{progress}%</span>
      </div>
      <div className="w-full bg-gray-200 rounded-full h-3">
        <div 
          className="bg-gradient-to-r from-primary to-secondary h-3 rounded-full transition-all duration-500 ease-out"
          style={{ 
            width: `${progress}%`,
            background: progress >= 100 ? 'var(--success)' : 'linear-gradient(to right, var(--primary), var(--secondary))'
          }}
        ></div>
      </div>
    </div>
  );
}