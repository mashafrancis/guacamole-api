import { FindManyOptions } from 'typeorm';

const arrayToObject = (arr: any[]) =>
	Object.assign({}, ...arr.map((item) => ({ ...item })));

export const typeormFilterMapper = (options: FindManyOptions) => {
	const filters = options.where;
	const where = {};
	// @ts-expect-error cannot change default
	Object.keys(filters).forEach((filterName) => {
		// @ts-expect-error cannot change default
		const operators = filters[filterName];
		const filter = Object.keys(operators).map((key) => {
			return mapToTypeOrm(key, operators);
		});
		// @ts-expect-error cannot change default
		where[filterName] = arrayToObject(filter);
	});

	return where;
};

const mapToTypeOrm = (key: string, filter: any): any => {
	switch (key) {
		case 'eq':
			return { $eq: filter[key] };
		case 'ne':
			return { $ne: filter[key] };
		case 'le':
			return { $lte: filter[key] };
		case 'lt':
			return { $lt: filter[key] };
		case 'ge':
			return { $gte: filter[key] };
		case 'gt':
			return { $gt: filter[key] };
		case 'in':
			return { $in: filter[key] };
		case 'nin':
			return { $nin: filter[key] };
		case 'contains':
			return { $regex: new RegExp(filter[key], 'gi') };
		case 'beginsWith':
			return { $regex: new RegExp(`^${filter[key]}`, 'gi') };
		case 'notContains':
			return { $not: new RegExp(filter[key]) };
		case 'between':
			return {
				$gte: filter[key][0],
				$lte: filter[key][1],
			};
	}
};