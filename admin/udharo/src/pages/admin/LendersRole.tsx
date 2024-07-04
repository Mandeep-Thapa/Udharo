import { useEffect, useState } from 'react';
import axios, { AxiosError } from 'axios';
import Navigationwrap from '@/components/Navigationwrap';
import { UserRole, ApiResponse } from '@/types';


const LenderRole = () => {
  const [lenderRoles, setLenderRoles] = useState<UserRole[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

  useEffect(() => {
    const fetchLenderRoles = async () => {
      const token = localStorage.getItem('token');
      try {
        const response = await axios.get<ApiResponse>(`${API_BASE_URL}/lenderRole`, {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        });
        setLenderRoles(response.data.data.users);
      } catch (err) {
        if (axios.isAxiosError(err)) {
          const axiosError = err as AxiosError;
          setError(axiosError.message);
        } else {
          setError('An unexpected error occurred');
        }
      } finally {
        setLoading(false);
      }
    };

    fetchLenderRoles();
  }, [API_BASE_URL]);

  return (
    <Navigationwrap>
      <div className="mt-[76px] xs:ml-0 sm:ml-[260px] p-3">
        <h2 className="font-bold text-3xl mx-3 mb-4">Lender Roles</h2>
        {loading ? (
          <div className="flex justify-center mt-10 h-screen">
          <div className="w-16 h-16 border-4 border-custom-sudesh_blue border-dotted rounded-full animate-spin"></div>
        </div>
        ) : error ? (
          <div className="text-center text-red-500">Error: {error}</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="min-w-full bg-white border border-gray-200">
              <thead className="bg-custom-sudesh_blue text-white">
                <tr>
                  <th className="px-2 py-3 text-left text-xs font-medium uppercase tracking-wider">Full Name</th>
                  <th className="px-2 py-3 text-left text-xs font-medium uppercase tracking-wider">Email</th>
                  <th className="px-2 py-3 text-left text-xs font-medium uppercase tracking-wider">Occupation</th>
                  <th className="px-2 py-3 text-left text-xs font-medium uppercase tracking-wider">User Role</th>
                  <th className="px-2 py-3 text-left text-xs font-medium uppercase tracking-wider">Risk Factor</th>
                  <th className="px-2 py-3 text-left text-xs font-medium uppercase tracking-wider">Verification Status</th>
                  <th className="px-2 py-3 text-left text-xs font-medium uppercase tracking-wider">Money Invested</th>
                  <th className="px-2 py-3 text-left text-xs font-medium uppercase tracking-wider">Timely Repayment</th>
                  <th className="px-2 py-3 text-left text-xs font-medium uppercase tracking-wider">Late Repayment</th>
                  <th className="px-2 py-3 text-left text-xs font-medium uppercase tracking-wider">Email Verified</th>
                  <th className="px-2 py-3 text-left text-xs font-medium uppercase tracking-wider">KYC Verified</th>
                  <th className="px-2 py-3 text-left text-xs font-medium uppercase tracking-wider">PAN Verified</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {lenderRoles.map((user) => (
                  <tr key={user._id} className="cursor-pointer hover:bg-gray-50">
                    <td className="px-2 py-4 whitespace-nowrap uppercase">{user.fullName}</td>
                    <td className="px-2 py-4 whitespace-nowrap">{user.email}</td>
                    <td className="px-2 py-4 whitespace-nowrap uppercase">{user.occupation}</td>
                    <td className="px-2 py-4 whitespace-nowrap">{user.userRole}</td>
                    <td className="px-2 py-4 whitespace-nowrap uppercase">{user.riskFactor}</td>
                    <td className="px-2 py-4 whitespace-nowrap">{user.riskFactorDetails.verificationStatus}</td>
                    <td className="px-2 py-4 whitespace-nowrap">{user.riskFactorDetails.moneyInvested}</td>
                    <td className="px-2 py-4 whitespace-nowrap">{user.riskFactorDetails.timelyRepayment}</td>
                    <td className="px-2 py-4 whitespace-nowrap">{user.riskFactorDetails.lateRepayment}</td>
                    <td className="px-2 py-4 whitespace-nowrap">{user.is_verifiedDetails.is_emailVerified ? 'Yes' : 'No'}</td>
                    <td className="px-2 py-4 whitespace-nowrap">{user.is_verifiedDetails.is_kycVerified ? 'Yes' : 'No'}</td>
                    <td className="px-2 py-4 whitespace-nowrap">{user.is_verifiedDetails.is_panVerified ? 'Yes' : 'No'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </Navigationwrap>
  );
};

export default LenderRole;
