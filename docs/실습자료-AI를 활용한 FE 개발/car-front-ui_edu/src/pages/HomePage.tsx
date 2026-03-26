/**
 * 홈 페이지 컴포넌트
 */
import React from "react";

const HomePage: React.FC = () => {
  return (
    <div className="space-y-6">
      <div className="bg-white overflow-hidden shadow rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">
            AGS 운영관리 시스템에 오신 것을 환영합니다
          </h2>
          <p className="text-gray-600 mb-6">
            글로벌 인재풀, 프로젝트, 센터, 보안을 통합 관리하는 시스템입니다.
          </p>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {/* 인재풀 관리 카드 */}
            <div className="bg-blue-50 p-6 rounded-lg">
              <h3 className="text-lg font-semibold text-blue-900 mb-2">
                인재풀 관리
              </h3>
              <p className="text-blue-700 text-sm">
                글로벌 인재 정보를 체계적으로 관리하고 활용합니다.
              </p>
            </div>

            {/* 프로젝트 관리 카드 */}
            <div className="bg-green-50 p-6 rounded-lg">
              <h3 className="text-lg font-semibold text-green-900 mb-2">
                프로젝트 관리
              </h3>
              <p className="text-green-700 text-sm">
                프로젝트 진행 상황과 리소스를 효율적으로 관리합니다.
              </p>
            </div>

            {/* 센터 관리 카드 */}
            <div className="bg-purple-50 p-6 rounded-lg">
              <h3 className="text-lg font-semibold text-purple-900 mb-2">
                센터 관리
              </h3>
              <p className="text-purple-700 text-sm">
                글로벌 센터 정보와 운영 현황을 관리합니다.
              </p>
            </div>

            {/* 보안 관리 카드 */}
            <div className="bg-red-50 p-6 rounded-lg">
              <h3 className="text-lg font-semibold text-red-900 mb-2">
                보안 관리
              </h3>
              <p className="text-red-700 text-sm">
                시스템 보안과 접근 권한을 체계적으로 관리합니다.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default HomePage;
