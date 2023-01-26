export interface Meal {
    id: number;
    title: string;
    imagePath: string;
    ingredients: string[];
    directions: string[];
    category: string;
}

export const MEALS: Meal[] = [
    { id: 1, title: "Soup", imagePath: "assets/images/pexels-foodie-factor-539451-soup.jpg", ingredients: ["Tomato","Basil","Onion"], directions: ["Mix","Cook","Serve"], category: "Lunch"},
    { id: 2, title: "Hamburger", imagePath: "assets/images/pexels-daniel-reche-3616956-burger.jpg", ingredients: ["i1","i2","i3"], directions: ["d1","d2","d3"], category: "Dinner"}
];