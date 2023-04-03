import { UserEntity } from '../entities/user.entity';
import { UserResponseDto } from './user-response.dto';

export const UserMapper = () => {
  function toResponse(user: UserEntity): UserResponseDto {
    return {
      _id: user._id,
      name: user.name,
      login: user.login,
      timestamp: user.timestamp,
    };
  }

  function toResponseList(users: UserEntity[]): UserResponseDto[] {
    return users.map((user: UserEntity) => ({
      _id: user._id,
      name: user.name,
      login: user.login,
      timestamp: user.timestamp,
    }));
  }

  return { toResponse, toResponseList };
};
