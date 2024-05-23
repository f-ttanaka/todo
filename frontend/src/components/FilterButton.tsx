type ButtonProps = JSX.IntrinsicElements['button'] & {
  label: string
}

const FilterButton = (props: ButtonProps) => {
  return (
    <button {...props} type='button' className='btn toggle-btn'>
      <span className='visually-hidden'>Show </span>
      <span>{props.label}</span>
      <span className='visually-hidden'> tasks</span>
    </button>
  )
}

export default FilterButton
