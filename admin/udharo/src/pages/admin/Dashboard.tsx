import axios from "axios";
import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import Cookies from "js-cookie";
import Navigationwrap from "../../components/Navigationwrap";
import { FaUser, FaRegMoneyBillAlt } from "react-icons/fa";
import { LiaBlenderSolid } from "react-icons/lia";
import { HiUserGroup } from "react-icons/hi";
interface AdminDetails {
  email: string;
}

const Dashboard: React.FC = () => {
  const [adminDetails, setAdminDetails] = useState<AdminDetails | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const navigate = useNavigate();
  const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

  useEffect(() => {
    const fetchAdminDetails = async () => {
      try {
        const authToken = Cookies.get("authToken");
        const response = await axios.get(`${API_BASE_URL}/admindetails`, {
          headers: {
            Authorization: `Bearer ${authToken}`,
          },
        });
        setAdminDetails(response.data);
        setLoading(false);

        if (!response.data) {
          navigate("/");
        }
      } catch {
        console.log("Error fetching admin details:", Error);
        setLoading(false);
      }
    };
    fetchAdminDetails();
  }, []);

  return (
    <>
      <Navigationwrap>
        <div className=" mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col">
          <h1 className="text-3xl font-bold"></h1>
          {loading ? (
            <div className="flex justify-center mt-10 h-screen">
              <div className="w-16 h-16 border-4 border-custom-sudesh_blue border-dotted rounded-full animate-spin"></div>
            </div>
          ) : (
            adminDetails && (
              <div className="text-xl font-bold flex flex-wrap">
                <div className="border rounded-md flex p-3 justify-start items-center mt-2">
                  <span className="mx-3">Admin:</span> {adminDetails.email}
                </div>
              </div>
            )
          )}
          <div className="rounded-lg grid xs:grid-cols-1 md:grid-cols-3 m-4">
            <a href="/users">
              <div className=" rounded-md hover:cursor-pointer bg-custom-sudesh_yellow hover:transition  duration-700 flex items-center flex-col m-3 p-3 h-36">
                <h1 className="text-2xl font-bold m-3">All Users</h1>
                <span className=" text-4xl">
                  <FaUser />
                </span>
              </div>
            </a>

            <div className=" rounded-md hover:cursor-pointer bg-custom-sudesh_blue hover:transition  duration-700 flex items-center flex-col m-3 p-3 h-36">
              <h1 className="text-2xl font-bold m-3">Lenders</h1>
              <span className=" text-4xl">
                <FaRegMoneyBillAlt />
              </span>
            </div>
            <div className=" rounded-md hover:cursor-pointer bg-custom-sudesh_dark_gray hover:transition  duration-700 flex items-center flex-col m-3 p-3 h-36">
              <h1 className="text-2xl font-bold m-3">Borrowers</h1>
              <span className=" text-4xl">
                <LiaBlenderSolid />
              </span>
            </div>
            <a href="/approvedborrowrequest">
              <div className=" rounded-md hover:cursor-pointer bg-custom-sudesh_blue hover:transition  duration-700 flex items-center flex-col m-3 p-3 h-36">
                <h1 className="text-2xl font-bold m-3">
                  Approved Borrow Request
                </h1>
                <span className=" text-4xl">
                  <FaUser />
                </span>
              </div>
            </a>
            <div className=" rounded-md hover:cursor-pointer bg-custom-sudesh_yellow hover:transition  duration-700 flex items-center flex-col m-3 p-3 h-36">
              <h1 className="text-2xl font-bold m-3">Our Team</h1>
              <span className=" text-4xl">
                <HiUserGroup />
              </span>
            </div>
          </div>
        </div>
      </Navigationwrap>
    </>
  );
};

export default Dashboard;
