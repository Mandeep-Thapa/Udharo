import React,{ReactNode} from 'react'
import Navigation from '../pages/Navigation'

interface LayoutProps {
   children: ReactNode;
 }
 
const Navigationwrap: React.FC<LayoutProps> = ({children}) => {
  return (
   <div className=''>
   <Navigation />
   <div className="">{children}</div>
 </div>
  )
}

export default Navigationwrap
