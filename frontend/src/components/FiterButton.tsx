type ButtonProps = JSX.IntrinsicElements["button"] & {
  label : string
};

const FilterButton = (props: ButtonProps) => {
  return (
    <button
      {...props}
      type="button"
      className="border border-[#d3d3d3]"
    >
      <span className="absolute h-[1px] w-[1px] overflow-hidden whitespace-nowrap">Show </span>
      <span>{props.label}</span>
      <span className="absolute h-[1px] w-[1px] overflow-hidden whitespace-nowrap"> tasks</span>
    </button>
  );
}

export default FilterButton