export const FETCH_CARD = 'FETCH CARD';

export default function fetchCard() {
  return {
    type: FETCH_CARD,
    payload: request
  };
}
