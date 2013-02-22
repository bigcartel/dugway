module Dugway
  module Filters
    module ComparisonFilters
      def num_gt(input, operand)
        to_number(input) > to_number(operand)
      end

      def num_lt(input, operand)
        to_number(input) < to_number(operand)
      end

      def num_eq(input, operand)
        to_number(input) == to_number(operand)
      end

      def num_lte(input, operand)
        num_eq(input, operand) || num_lt(input, operand)
      end

      def num_gte(input, operand)
        num_eq(input, operand) || num_gt(input, operand)
      end

      private

      def to_number(obj)
        case obj
        when Numeric
          obj
        when String
          (obj.strip =~ /^\d+\.\d+$/) ? obj.to_f : obj.to_i
        else
          0
        end
      end
    end
  end
end

Liquid::Condition.send(:include, Dugway::Filters::ComparisonFilters)

Liquid::Condition.class_eval do
  operators['num_lt']  = lambda { |cond, left, right| cond.num_lt(left, right) }
  operators['num_lte'] = lambda { |cond, left, right| cond.num_lte(left, right) }
  operators['num_gt']  = lambda { |cond, left, right| cond.num_gt(left, right) }
  operators['num_gte'] = lambda { |cond, left, right| cond.num_gte(left, right) }
  operators['num_eq']  = lambda { |cond, left, right| cond.num_eq(left, right) }
end
