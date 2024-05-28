import React from "react";
import { useParams } from "react-router-dom";
import axios from "axios";
import { useState, useEffect } from "react";
import Navigationwrap from "../../components/Navigationwrap";
import { FaUser } from "react-icons/fa";
import { PiGenderNeuterBold } from "react-icons/pi";
import { FaUserTie } from "react-icons/fa6";
import { MdOutlineVerified } from "react-icons/md";
import { FaArrowRight } from "react-icons/fa6";
import { IoIosCloseCircle } from "react-icons/io";
import { Toaster } from "@/components/ui/sonner";
import { toast } from "sonner";

interface KycDetailsProps {
  _id: string;
  userId: string;
  firstName: string;
  lastName: string;
  gender: string;
  photo: string;
  citizenshipNumber: number;
  citizenshipFrontPhoto: string;
  citizenshipBackPhoto: string;
  isKYCVerified: boolean;
  __v: number;
}

const KycDetails: React.FC = () => {
  const { _id } = useParams<{ _id: string }>();
  const [kycdetails, setKycDetails] = useState<KycDetailsProps | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [showModal, setShowModal] = useState<boolean>(false);
  const [modalImage, setModalImage] = useState<string>("");

  useEffect(() => {
    const fetchKycDetails = async () => {
      try {
        const token = localStorage.getItem("token");
        if (!token) {
          throw new Error("Authentication token not found");
        }
        const response = await axios.get(
          `http://localhost:3004/api/admin/kycDetails/${_id}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );
        setKycDetails(response.data.messgae);
        setLoading(false);
      } catch (error) {
        if (axios.isAxiosError(error)) {
          console.log("Axios error occured:", error);
          if (error.response) {
            toast.error(
              `Error: ${error.response.status} - ${error.response.data.message}`
            );
          } else if (error.request) {
            toast.error(
              "Error: No response from server. Please try again later."
            );
          } else {
            toast.error(`Error: ${error.message}`);
          }
        } else {
          console.error("Non-Axios error occurred:", error);
          toast(`Error: ${(error as Error).message}`);
        }
        setLoading(false);
      }
    };
    fetchKycDetails();
  }, [_id]);
  const handelphoto = (photo: string) => {
    setModalImage(photo);
    setShowModal(true);
  };
  const closeModal = () => {
    setShowModal(false);
    setModalImage("");
  };
  const toggleKycVerification = async () => {
    if (!kycdetails) return;
    try {
      const token = localStorage.getItem("token");
      if (!token) {
        throw new Error("Authentication token not found");
      }
      const updatedStatus = !kycdetails.isKYCVerified;
      const response = await axios.put(
        `http://localhost:3004/api/admin/verifyKYC/${kycdetails?.userId}`,
        {
          isKYCVerified: updatedStatus,
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
        
      );
      setKycDetails((prevState) => {
        if (prevState) {
          return {
            ...prevState,
            isKYCVerified: updatedStatus,
          };
        }
        return prevState;
      });
      console.log(response);
    } catch (error) {
      if (axios.isAxiosError(error)) {
        console.log("Axios error occurred:", error);
        if (error.response && error.response.status === 400) {
          toast.error(`${error.response.data.message}`);
        } else if (error.request) {
          toast.error(
            "Error: No response from server. Please try again later."
          );
        } else {
          toast.error(`Error: ${error.message}`);
        }
      } else {
        toast.error(`Error: ${(error as Error).message}`);
      }
    }
  };

  return (
    <>
      <Navigationwrap>
        <div className="mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col">
          <h1 className="font-bold text-3xl mx-3">KYC Details</h1>
          {loading ? (
            <div className="flex justify-center mt-10 h-screen">
              <div className="w-16 h-16 border-4 border-yellow-500 border-dotted rounded-full animate-spin"></div>
            </div>
          ) : (
            kycdetails && (
              <div
                className="mt-3 m-2 p-2 rounded-md flex flex-col border border-orange-300"
                key={_id}
              >
                <div className="grid grid-cols-2">
                  <div className="m-3 p-1">
                    <img
                      src={kycdetails.photo}
                      alt="User Photo"
                      className="w-[300px] h-[300px] object-cover rounded-full mx-auto m-2"
                    />
                    <p className="text-center text-2xl font-bold">
                      {kycdetails.firstName.charAt(0).toUpperCase() +
                        kycdetails.firstName.slice(1)}{" "}
                      {kycdetails.lastName}
                    </p>
                  </div>
                  <div className="flex flex-col items-start p-3 m-3 w-full">
                    <div className="mb-2 p-1 w-full border  bg-custom-sudesh_yellow rounded-md">
                      <p className="font-bold p-2 flex gap-2 items-center">
                        <FaUser /> Full Name
                      </p>
                      <p className="p-2 flex gap-3 items-center">
                        <FaArrowRight />
                        {kycdetails.firstName.charAt(0).toUpperCase() +
                          kycdetails.firstName.slice(1)}{" "}
                        {kycdetails.lastName}
                      </p>
                    </div>
                    <div className="mb-2 p-1 w-full border bg-custom-sudesh_yellow rounded-md">
                      <p className="font-bold p-2 flex gap-3 items-center">
                        <PiGenderNeuterBold />
                        Gender:
                      </p>
                      <p className="p-2 flex gap-3 items-center">
                        <FaArrowRight />
                        {kycdetails.gender.charAt(0).toUpperCase() +
                          kycdetails.gender.slice(1)}
                      </p>
                    </div>
                    <div className="mb-2 p-1 w-full border bg-custom-sudesh_yellow rounded-md">
                      <p className="font-bold p-2 flex gap-3">
                        <FaUserTie />
                        Citizenship Number:
                      </p>
                      <p className="p-2 flex gap-3 items-center">
                        <FaArrowRight />
                        {kycdetails.citizenshipNumber}
                      </p>
                    </div>

                    <div className="mb-2 p-1 w-full border bg-custom-sudesh_yellow rounded-md">
                      <p className="font-bold p-2 flex gap-3 items-center">
                        <MdOutlineVerified />
                        KYC Verified:
                      </p>
                      <p className="p-2 flex gap-3 items-center">
                        <FaArrowRight />
                        {kycdetails.isKYCVerified ? "Yes" : "No"}
                      </p>
                    </div>
                    <div className="mt-2">
                      <button
                        onClick={toggleKycVerification}
                        className={`px-4 py-2 rounded-md text-white ${
                          kycdetails.isKYCVerified
                            ? "bg-red-500 hover:bg-red-600"
                            : "bg-green-500 hover:bg-green-600"
                        }`}
                      >
                        {kycdetails.isKYCVerified
                          ? "Unverify KYC"
                          : "Verify KYC"}
                      </button>
                    </div>
                  </div>
                </div>
                <div className="grid grid-cols-2 gap-1">
                  <div className="mb-4 p-1">
                    <p className="font-bold p-2">Citizenship Front Photo</p>
                    <img
                      src={kycdetails.citizenshipFrontPhoto}
                      alt="Citizenship Front Photo"
                      className="w-full h-[300px] object-cover mx-auto rounded-md"
                      onClick={() =>
                        handelphoto(kycdetails.citizenshipFrontPhoto)
                      }
                    />
                  </div>
                  <div className="mb-4 p-1">
                    <p className="font-bold p-2">Citizenship Back Photo</p>
                    <img
                      src={kycdetails.citizenshipBackPhoto}
                      alt="Citizenship Back Photo"
                      className="hover:cursor-pointer w-full h-[300px] object-cover mx-auto rounded-md"
                      onClick={() =>
                        handelphoto(kycdetails.citizenshipBackPhoto)
                      }
                    />
                  </div>
                </div>
                {showModal && (
                  <div className="fixed inset-0 flex justify-center items-center z-50">
                    <div className="absolute inset-0 bg-gray-800 bg-opacity-30 backdrop-blur-sm"></div>
                    <div className="relative bg-white rounded-lg shadow-lg w-[90%] max-w-[900px] max-h-[80%] overflow-hidden">
                      <div className="flex justify-end p-2">
                        <button onClick={closeModal}>
                          <IoIosCloseCircle className="text-gray-600 text-4xl hover:text-gray-800 transition duration-700 hover:rotate-90" />
                        </button>
                      </div>
                      <div className="p-2 flex justify-center items-center">
                        <img
                          src={modalImage}
                          alt="Citizenship Photo"
                          className="max-w-full max-h-full object-contain rounded-md"
                        />
                      </div>
                    </div>
                  </div>
                )}
              </div>
            )
          )}
        </div>
        <Toaster />
      </Navigationwrap>
    </>
  );
};

export default KycDetails;
